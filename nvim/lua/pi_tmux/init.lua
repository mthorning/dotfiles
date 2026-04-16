local context = require('pi_tmux.context')
local tmux = require('pi_tmux.tmux')

local M = {}

M.defaults = {
  max_context_lines = 300,
  max_context_bytes = 24000,
  selection_context_lines = 40,
  pane_percentage = 33,
  startup_delay_ms = 400,
  focus_pane = true,
  helper_command = '~/dotfiles/bin/tmux-pi',
  append_system_prompt = context.system_prompt_for({ mode = 'chat' }),
}

local values = vim.deepcopy(M.defaults)
local last_target_pane = nil

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO)
end

local function get_pi_rpc_cmd()
  return {
    'pi',
    '--mode',
    'rpc',
    '--no-session',
    '--append-system-prompt',
    context.system_prompt_for({ mode = 'apply' }),
  }
end

local function reload_source_buffer(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if vim.bo[bufnr].modified or not context.buffer_is_file_backed(bufnr) then
    return false
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if vim.fn.filereadable(path) ~= 1 then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return false
  end

  local view = nil
  local current = vim.api.nvim_get_current_buf()
  if current == bufnr then
    view = vim.fn.winsaveview()
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modified = false

  if current == bufnr and view then
    pcall(vim.fn.winrestview, view)
  end

  return true
end

local function save_source_buffer(bufnr, command_name)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  if not context.buffer_is_file_backed(bufnr) then
    return false
  end
  if not vim.bo[bufnr].modified then
    return true
  end

  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd('silent write')
  end)
  if not ok then
    notify(string.format('%s failed to save buffer: %s', command_name, tostring(err)), vim.log.levels.ERROR)
    return false
  end

  return true
end

local function read_file_text(path)
  if not path or path == '' or vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  return table.concat(lines, '\n')
end

local function decode_rpc_event(line)
  local ok, event = pcall(vim.json.decode, line)
  if not ok then
    return nil
  end
  return event
end

local function record_rpc_event(state, event)
  if not event or not event.type then
    return
  end

  if event.type == 'agent_end' or event.type == 'turn_end' then
    state.saw_done = true
  elseif event.type == 'response' and event.success == false then
    state.response_error = event.error or 'unknown error'
  elseif event.type == 'message_update' then
    local delta = event.assistantMessageEvent
    if delta and delta.type == 'error' then
      state.response_error = delta.reason or 'unknown error'
    end
  end
end

local function feed_rpc_stream(state, key, chunk, on_stderr)
  if not chunk or chunk == '' then
    return
  end

  state[key] = (state[key] or '') .. chunk

  while true do
    local newline = state[key]:find('\n', 1, true)
    if not newline then
      break
    end

    local line = state[key]:sub(1, newline - 1)
    state[key] = state[key]:sub(newline + 1)

    if line ~= '' then
      local event = decode_rpc_event(line)
      if event then
        record_rpc_event(state, event)
      elseif on_stderr then
        on_stderr(line)
      end
    end
  end
end

local function run_apply(message, built_context, source_bufnr)
  local payload = vim.json.encode({
    type = 'prompt',
    message = context.compose_message(message, built_context),
  }) .. '\n'

  local source_path = source_bufnr and vim.api.nvim_buf_get_name(source_bufnr) or nil
  local before_text = read_file_text(source_path)
  local state = {
    stdout_tail = '',
    stderr_tail = '',
    saw_done = false,
    response_error = nil,
    stderr_lines = {},
  }

  notify('Pi applying change...')

  local process = vim.system(get_pi_rpc_cmd(), {
    text = true,
    stdin = true,
    stdout = vim.schedule_wrap(function(err, data)
      if err then
        notify('Pi apply failed: ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      feed_rpc_stream(state, 'stdout_tail', data)
    end),
    stderr = vim.schedule_wrap(function(err, data)
      if err then
        notify('Pi apply failed: ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      feed_rpc_stream(state, 'stderr_tail', data, function(line)
        state.stderr_lines[#state.stderr_lines + 1] = line
      end)
    end),
  }, vim.schedule_wrap(function(result)
    if state.stdout_tail ~= '' then
      local event = decode_rpc_event(state.stdout_tail)
      if event then
        record_rpc_event(state, event)
      end
      state.stdout_tail = ''
    end

    if state.stderr_tail ~= '' then
      state.stderr_lines[#state.stderr_lines + 1] = state.stderr_tail
      state.stderr_tail = ''
    end

    if result.code ~= 0 then
      local err = table.concat(state.stderr_lines, '\n')
      if err == '' then
        err = 'pi exited with code ' .. tostring(result.code)
      end
      notify('Pi apply failed: ' .. err, vim.log.levels.ERROR)
      return
    end

    if state.response_error then
      notify('Pi apply failed: ' .. tostring(state.response_error), vim.log.levels.ERROR)
      return
    end

    if not state.saw_done then
      notify('Pi apply did not complete; pi exited before finishing the request', vim.log.levels.ERROR)
      return
    end

    reload_source_buffer(source_bufnr)

    local after_text = read_file_text(source_path)
    if before_text == after_text then
      notify('Pi finished but made no file changes', vim.log.levels.WARN)
      return
    end

    notify('Pi applied change')
  end))

  local wrote, write_err = pcall(process.write, process, payload)
  if not wrote then
    pcall(process.kill, process, 15)
    notify('Pi apply failed: ' .. tostring(write_err), vim.log.levels.ERROR)
    return
  end

end

local function assert_supported_version()
  if vim.fn.has('nvim-0.10') == 0 then
    error('pi_tmux requires Neovim 0.10+')
  end
end

local function ensure_file_backed_buffer(command_name)
  local bufnr = vim.api.nvim_get_current_buf()
  if not context.buffer_is_file_backed(bufnr) then
    notify(string.format('%s requires a file-backed buffer', command_name), vim.log.levels.ERROR)
    return nil
  end
  return bufnr
end

local function ensure_visual_selection(command_name)
  local bufnr = ensure_file_backed_buffer(command_name)
  if not bufnr then
    return nil, nil
  end

  local range = context.get_visual_selection_range()
  if not range then
    notify(string.format('%s requires a visual selection', command_name), vim.log.levels.WARN)
    return nil, nil
  end

  return bufnr, range
end

local function validate(opts)
  for _, key in ipairs({ 'max_context_lines', 'max_context_bytes', 'selection_context_lines', 'pane_percentage', 'startup_delay_ms' }) do
    if opts[key] ~= nil and (type(opts[key]) ~= 'number' or opts[key] < 1) then
      error(string.format('pi_tmux: %s must be a positive number', key))
    end
  end

  if opts.focus_pane ~= nil and type(opts.focus_pane) ~= 'boolean' then
    error('pi_tmux: focus_pane must be a boolean')
  end

  if opts.helper_command ~= nil and type(opts.helper_command) ~= 'string' then
    error('pi_tmux: helper_command must be a string')
  end
end

local function get()
  return values
end

local function select_target_pane(force_new)
  local cfg = get()

  if not force_new then
    local reused, reuse_reason = tmux.find_reusable_pi_pane()
    if reused then
      return reused, reuse_reason
    end
  end

  local created, create_err = tmux.create_pi_pane(cfg)
  if not created then
    return nil, create_err
  end

  return created, 'created new pi pane'
end

local function dispatch_chat(message, build_context, opts)
  opts = opts or {}

  if not tmux.inside_tmux() then
    notify('PiAsk requires Neovim to be running inside tmux', vim.log.levels.ERROR)
    return
  end

  if not message or message == '' then
    notify('No message provided', vim.log.levels.WARN)
    return
  end

  local source_bufnr = vim.api.nvim_get_current_buf()
  if not save_source_buffer(source_bufnr, opts.command_name or 'PiChatSelection') then
    return
  end

  local ok, built_context = pcall(build_context)
  if not ok then
    notify(built_context, vim.log.levels.ERROR)
    return
  end

  local prompt = context.compose_message(message, built_context)

  local pane, pane_result = select_target_pane(opts.force_new)
  if not pane then
    notify('Failed to open tmux pi pane: ' .. tostring(pane_result), vim.log.levels.ERROR)
    return
  end

  local ready, ready_err = tmux.ensure_pi_ready(pane, get())
  if not ready then
    notify('Failed to start pi in tmux pane: ' .. tostring(ready_err), vim.log.levels.ERROR)
    return
  end

  local sent, send_err = tmux.send_prompt(pane.pane_id, prompt)
  if not sent then
    notify('Failed to send prompt to tmux pane: ' .. tostring(send_err), vim.log.levels.ERROR)
    return
  end

  last_target_pane = pane.pane_id

  if get().focus_pane then
    local focused, focus_err = tmux.focus_pane(pane.pane_id)
    if not focused then
      notify('Sent prompt but failed to focus pane: ' .. tostring(focus_err), vim.log.levels.WARN)
      return
    end
  end

  notify(string.format('Prompt sent to %s (%s)', pane.pane_id, pane_result))
end

local function dispatch_apply(message, build_context)
  if not message or message == '' then
    notify('No message provided', vim.log.levels.WARN)
    return
  end

  local source_bufnr = vim.api.nvim_get_current_buf()
  if not save_source_buffer(source_bufnr, 'PiApplySelection') then
    return
  end

  local ok, built_context = pcall(build_context)
  if not ok then
    notify(built_context, vim.log.levels.ERROR)
    return
  end

  run_apply(message, built_context, source_bufnr)
end

local function prompt_with_context(command_name, build_context, opts)
  assert_supported_version()
  local bufnr = ensure_file_backed_buffer(command_name)
  if not bufnr then
    return
  end

  local range = opts and opts.selection and context.get_visual_selection_range() or nil
  local cursor = opts and opts.cursor and context.get_cursor_position() or nil
  vim.ui.input({ prompt = context.format_prompt_label(bufnr, range, cursor) }, function(input)
    if input then
      if opts and opts.mode == 'apply' then
        dispatch_apply(input, build_context)
      else
        dispatch_chat(input, build_context, vim.tbl_extend('force', opts or {}, { command_name = command_name }))
      end
    end
  end)
end

function M.setup(opts)
  assert_supported_version()
  opts = opts or {}
  validate(opts)
  values = vim.tbl_extend('force', vim.deepcopy(M.defaults), opts)
  return values
end

function M.ask()
  return M.chat()
end

function M.ask_selection()
  return M.chat_selection()
end

function M.chat()
  local bufnr = ensure_file_backed_buffer('PiChatHere')
  if not bufnr then
    return
  end

  prompt_with_context('PiChatHere', function()
    return context.get_cursor_context(bufnr, get(), { mode = 'chat' })
  end, { force_new = false, cursor = true, mode = 'chat' })
end

function M.chat_selection()
  local bufnr = ensure_file_backed_buffer('PiChatSelection')
  if not bufnr then
    return
  end

  local range = context.get_visual_selection_range()
  if not range then
    notify('PiChatSelection requires a visual selection', vim.log.levels.WARN)
    return
  end

  prompt_with_context('PiChatSelection', function()
    return context.get_visual_context(bufnr, get(), { mode = 'chat' })
  end, { force_new = false, selection = true, mode = 'chat' })
end

function M.ask_new()
  return M.chat_new()
end

function M.ask_new_selection()
  return M.chat_new_selection()
end

function M.chat_new()
  local bufnr = ensure_file_backed_buffer('PiNewPane')
  if not bufnr then
    return
  end

  prompt_with_context('PiNewPane', function()
    return context.get_cursor_context(bufnr, get(), { mode = 'chat' })
  end, { force_new = true, cursor = true, mode = 'chat' })
end

function M.chat_new_selection()
  local bufnr = ensure_file_backed_buffer('PiNewSelection')
  if not bufnr then
    return
  end

  local range = context.get_visual_selection_range()
  if not range then
    notify('PiNewSelection requires a visual selection', vim.log.levels.WARN)
    return
  end

  prompt_with_context('PiNewSelection', function()
    return context.get_visual_context(bufnr, get(), { mode = 'chat' })
  end, { force_new = true, selection = true, mode = 'chat' })
end

function M.apply()
  notify('Use PiApplySelection from visual mode', vim.log.levels.WARN)
end

function M.apply_selection()
  local bufnr = ensure_file_backed_buffer('PiApplySelection')
  if not bufnr then
    return
  end

  local range = context.get_visual_selection_range()
  if not range then
    notify('PiApplySelection requires a visual selection', vim.log.levels.WARN)
    return
  end

  prompt_with_context('PiApplySelection', function()
    return context.get_visual_context(bufnr, get(), { mode = 'apply' })
  end, { selection = true, mode = 'apply' })
end

function M.focus_last()
  if not tmux.inside_tmux() then
    notify('PiFocus requires Neovim to be running inside tmux', vim.log.levels.ERROR)
    return
  end

  if not last_target_pane then
    notify('No Pi tmux pane has been used yet', vim.log.levels.WARN)
    return
  end

  local ok, err = tmux.focus_pane(last_target_pane)
  if not ok then
    notify('Failed to focus pane: ' .. tostring(err), vim.log.levels.ERROR)
    return
  end

  notify('Focused ' .. last_target_pane)
end

function M.debug_window()
  if not tmux.inside_tmux() then
    notify('PiDebug requires Neovim to be running inside tmux', vim.log.levels.ERROR)
    return
  end

  local description, err = tmux.describe_current_window()
  if not description then
    notify('Failed to inspect tmux panes: ' .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.notify(description, vim.log.levels.INFO, { title = 'pi_tmux panes' })
end

return M

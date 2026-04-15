local M = {}

local function trim(value)
  return (value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function run_tmux(args, input)
  local result = vim.system(vim.list_extend({ 'tmux' }, args), {
    text = true,
    stdin = input,
  }):wait()

  if result.code ~= 0 then
    return nil, trim(result.stderr ~= '' and result.stderr or result.stdout)
  end

  return trim(result.stdout), nil
end

function M.inside_tmux()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= '' and vim.env.TMUX_PANE ~= nil and vim.env.TMUX_PANE ~= ''
end

function M.current_pane_id()
  return vim.env.TMUX_PANE
end

function M.current_window_id()
  if not M.inside_tmux() then
    return nil, 'Not running inside tmux'
  end
  return run_tmux({ 'display-message', '-p', '-t', M.current_pane_id(), '#{window_id}' })
end

function M.current_path()
  if not M.inside_tmux() then
    return nil, 'Not running inside tmux'
  end
  return run_tmux({ 'display-message', '-p', '-t', M.current_pane_id(), '#{pane_current_path}' })
end

local function parse_panes(output)
  local panes = {}
  for line in (output or ''):gmatch('[^\n]+') do
    local pane_id, window_id, pane_index, current_command, current_path, pane_active, pane_title = line:match('([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t(.*)')
    if pane_id and window_id then
      panes[#panes + 1] = {
        pane_id = pane_id,
        window_id = window_id,
        pane_index = tonumber(pane_index),
        current_command = current_command,
        current_path = current_path,
        active = pane_active == '1',
        title = pane_title,
      }
    end
  end
  return panes
end

local function is_pi_command(command)
  return command == 'pi' or command == 'ai'
end

local function has_pi_title(pane)
  local title = pane.title or ''
  local normalized = title:lower()
  return normalized == 'pi'
    or normalized:find('pi', 1, true) ~= nil
    or title:find('π', 1, true) ~= nil
end

local function is_pi_pane(pane)
  return is_pi_command(pane.current_command) or has_pi_title(pane)
end

local function is_running_pi(pane)
  return is_pi_command(pane.current_command)
end

function M.list_current_window_panes()
  local window_id, err = M.current_window_id()
  if not window_id then
    return nil, err
  end

  local output, list_err = run_tmux({
    'list-panes',
    '-t',
    window_id,
    '-F',
    '#{pane_id}\t#{window_id}\t#{pane_index}\t#{pane_current_command}\t#{pane_current_path}\t#{pane_active}\t#{pane_title}',
  })
  if not output then
    return nil, list_err
  end

  return parse_panes(output), nil
end

function M.get_pane(pane_id)
  local panes, err = M.list_current_window_panes()
  if not panes then
    return nil, err
  end

  for _, pane in ipairs(panes) do
    if pane.pane_id == pane_id then
      return pane, nil
    end
  end

  return nil, 'Pane not found: ' .. tostring(pane_id)
end

function M.find_reusable_pi_pane()
  local panes, err = M.list_current_window_panes()
  if not panes then
    return nil, err
  end

  local current_pane_id = M.current_pane_id()
  local active_match = nil

  for _, pane in ipairs(panes) do
    if pane.pane_id ~= current_pane_id and is_pi_pane(pane) then
      if not pane.active then
        return pane, 'reused existing pi pane'
      end
      active_match = active_match or pane
    end
  end

  if active_match then
    return active_match, 'reused active pi pane'
  end

  return nil, 'no existing pi pane found'
end

function M.create_pi_pane(config)
  local path, path_err = M.current_path()
  if not path then
    return nil, path_err
  end

  local helper_command = config.helper_command
  if config.append_system_prompt and config.append_system_prompt ~= '' then
    helper_command = helper_command .. ' --append-system-prompt ' .. vim.fn.shellescape(config.append_system_prompt)
  end

  local command = string.format("$SHELL -ic %s", vim.fn.shellescape(helper_command))
  local pane_id, err = run_tmux({
    'split-window',
    '-P',
    '-F',
    '#{pane_id}',
    '-h',
    '-p',
    tostring(config.pane_percentage),
    '-c',
    path,
    command,
  })
  if not pane_id then
    return nil, err
  end

  return {
    pane_id = pane_id,
    current_path = path,
    current_command = nil,
    title = 'pi',
    created = true,
  }, nil
end

function M.ensure_pi_ready(pane, config)
  if pane.created then
    local ready = vim.wait(config.startup_delay_ms * 3, function()
      local refreshed = M.get_pane(pane.pane_id)
      return refreshed and is_running_pi(refreshed)
    end, 50)
    if ready then
      vim.wait(config.startup_delay_ms)
      return true, nil
    end
  elseif is_running_pi(pane) then
    return true, nil
  end

  local cmd, err = run_tmux({ 'send-keys', '-t', pane.pane_id, 'pi', 'Enter' })
  if cmd == nil and err then
    return false, err
  end

  vim.wait(config.startup_delay_ms * 2)
  return true, nil
end

function M.send_prompt(pane_id, text)
  local buffer_name = string.format('pi-tmux-%d-%d', vim.loop.getpid(), vim.loop.hrtime())

  local _, load_err = run_tmux({ 'load-buffer', '-b', buffer_name, '-' }, text)
  if load_err then
    return false, load_err
  end

  local _, paste_err = run_tmux({ 'paste-buffer', '-d', '-p', '-t', pane_id, '-b', buffer_name })
  if paste_err then
    return false, paste_err
  end

  local _, enter_err = run_tmux({ 'send-keys', '-t', pane_id, 'Enter' })
  if enter_err then
    return false, enter_err
  end

  return true, nil
end

function M.focus_pane(pane_id)
  local _, err = run_tmux({ 'select-pane', '-t', pane_id })
  return err == nil, err
end

function M.describe_current_window()
  local panes, err = M.list_current_window_panes()
  if not panes then
    return nil, err
  end

  local lines = {}
  for _, pane in ipairs(panes) do
    lines[#lines + 1] = string.format(
      '%s active=%s cmd=%s title=%s path=%s',
      pane.pane_id,
      tostring(pane.active),
      pane.current_command,
      pane.title,
      pane.current_path
    )
  end

  return table.concat(lines, '\n'), nil
end

return M

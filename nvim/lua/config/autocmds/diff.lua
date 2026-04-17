local M = {}

local function show_alpha_if_current_buffer_is_empty()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) == '' and vim.api.nvim_buf_line_count(buf) <= 1 then
    local ok, alpha = pcall(require, 'alpha')
    if ok then
      alpha.start(false)
    end
  end
end

local function restore_previous_buffer_or_quit(prev_buf)
  vim.schedule(function()
    local has_real_buf = false
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
        and (vim.api.nvim_buf_get_name(b) ~= '' or vim.bo[b].modified) then
        has_real_buf = true
        break
      end
    end

    if not has_real_buf then
      vim.cmd('quit')
    elseif vim.api.nvim_buf_is_valid(prev_buf) then
      vim.api.nvim_set_current_buf(prev_buf)
    end
  end)
end

local function configure_diff_keymaps(bufnr)
  vim.keymap.set('n', 'q', '<CMD>bdelete<CR>', { buffer = bufnr, desc = 'Close diff buffer' })

  local ok, wk = pcall(require, 'which-key')
  if ok then
    wk.add({
      { '<leader>Ac', '<CMD>PiChatDiff<CR>',     buffer = bufnr, mode = 'n', desc = 'Pi chat diff' },
      { '<leader>Ac', ':<C-u>PiChatDiff<CR>',    buffer = bufnr, mode = 'v', desc = 'Pi chat diff' },
      { '<leader>An', '<CMD>PiChatDiffNew<CR>',  buffer = bufnr, mode = 'n', desc = 'Pi chat diff (new pane)' },
      { '<leader>An', ':<C-u>PiChatDiffNew<CR>', buffer = bufnr, mode = 'v', desc = 'Pi chat diff (new pane)' },
      { '<leader>ic', '<CMD>PiChatDiff<CR>',     buffer = bufnr, mode = 'n', desc = 'Pi chat diff' },
      { '<leader>ic', ':<C-u>PiChatDiff<CR>',    buffer = bufnr, mode = 'v', desc = 'Pi chat diff' },
      { '<leader>in', '<CMD>PiChatDiffNew<CR>',  buffer = bufnr, mode = 'n', desc = 'Pi chat diff (new pane)' },
      { '<leader>in', ':<C-u>PiChatDiffNew<CR>', buffer = bufnr, mode = 'v', desc = 'Pi chat diff (new pane)' },
      { '<leader>Aa', hidden = true,             buffer = bufnr, mode = 'v' },
      { '<leader>ia', hidden = true,             buffer = bufnr, mode = { 'n', 'v' } },
    })
    return
  end

  vim.keymap.set('n', '<leader>Ac', '<CMD>PiChatDiff<CR>', { buffer = bufnr, desc = 'Pi chat diff' })
  vim.keymap.set('v', '<leader>Ac', ':<C-u>PiChatDiff<CR>', { buffer = bufnr, desc = 'Pi chat diff' })
  vim.keymap.set('n', '<leader>An', '<CMD>PiChatDiffNew<CR>', { buffer = bufnr, desc = 'Pi chat diff (new pane)' })
  vim.keymap.set('v', '<leader>An', ':<C-u>PiChatDiffNew<CR>', { buffer = bufnr, desc = 'Pi chat diff (new pane)' })
  vim.keymap.set('n', '<leader>ic', '<CMD>PiChatDiff<CR>', { buffer = bufnr, desc = 'Pi chat diff' })
  vim.keymap.set('v', '<leader>ic', ':<C-u>PiChatDiff<CR>', { buffer = bufnr, desc = 'Pi chat diff' })
  vim.keymap.set('n', '<leader>in', '<CMD>PiChatDiffNew<CR>', { buffer = bufnr, desc = 'Pi chat diff (new pane)' })
  vim.keymap.set('v', '<leader>in', ':<C-u>PiChatDiffNew<CR>', { buffer = bufnr, desc = 'Pi chat diff (new pane)' })
end

local function create_diff_buffer(name, lines, prev_buf, metadata)
  vim.cmd('enew')
  vim.cmd('file ' .. name)

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  metadata = metadata or {}
  for key, value in pairs(metadata) do
    vim.b[buf][key] = value
  end

  vim.bo[buf].modifiable = false

  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buf,
    callback = function()
      restore_previous_buffer_or_quit(prev_buf)
    end,
  })

  return buf
end

local function open_jj_diff(args)
  local diff_output = vim.fn.systemlist('jj diff ' .. args)
  if vim.v.shell_error ~= 0 or #diff_output == 0 or (#diff_output == 1 and diff_output[1] == '') then
    vim.notify('No changes to show', vim.log.levels.INFO)
    show_alpha_if_current_buffer_is_empty()
    return
  end

  local prev_buf = vim.api.nvim_get_current_buf()
  local buf = create_diff_buffer('jj://diff', diff_output, prev_buf, {
    jj_diff_args = args,
    diff_source_type = 'jj',
  })

  local fs_handle = vim.uv.new_fs_event()
  local debounce_timer = vim.uv.new_timer()

  local function refresh_diff()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local new_output = vim.fn.systemlist('jj diff ' .. (vim.b[buf].jj_diff_args or ''))
    if vim.v.shell_error ~= 0 then
      return
    end

    local cursor_ok, cursor = pcall(vim.api.nvim_win_get_cursor, 0)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_output)
    vim.bo[buf].modifiable = false
    if cursor_ok then
      local max_line = vim.api.nvim_buf_line_count(buf)
      pcall(vim.api.nvim_win_set_cursor, 0, { math.min(cursor[1], max_line), cursor[2] })
    end
  end

  if fs_handle then
    fs_handle:start(vim.fn.getcwd(), { recursive = true }, vim.schedule_wrap(function(err)
      if err then
        return
      end
      debounce_timer:stop()
      debounce_timer:start(200, 0, vim.schedule_wrap(refresh_diff))
    end))
  end

  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buf,
    callback = function()
      if debounce_timer then
        debounce_timer:stop()
        debounce_timer:close()
      end
      if fs_handle then
        fs_handle:stop()
        fs_handle:close()
      end
    end,
  })
end

local function open_file_diff(file1, file2)
  if vim.fn.filereadable(file1) == 0 then
    vim.notify('File not found: ' .. file1, vim.log.levels.ERROR)
    return
  end

  if vim.fn.filereadable(file2) == 0 then
    vim.notify('File not found: ' .. file2, vim.log.levels.ERROR)
    return
  end

  if vim.fn.system({ 'cmp', '-s', file1, file2 }) == '' and vim.v.shell_error == 0 then
    vim.notify('No differences to show', vim.log.levels.INFO)
    return
  end

  local diff_output = vim.fn.systemlist({ 'git', '--no-pager', 'diff', '--no-index', '--no-color', '--', file1, file2 })
  if vim.v.shell_error > 1 or #diff_output == 0 or (#diff_output == 1 and diff_output[1] == '') then
    vim.notify('Failed to generate diff', vim.log.levels.ERROR)
    return
  end

  local prev_buf = vim.api.nvim_get_current_buf()
  create_diff_buffer(
    string.format('diff://%s..%s', vim.fn.fnamemodify(file1, ':t'), vim.fn.fnamemodify(file2, ':t')),
    diff_output,
    prev_buf,
    {
      diff_source_type = 'generic',
      diff_file1 = file1,
      diff_file2 = file2,
    }
  )
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePost' }, {
    desc = 'Configure scratch buffers used for diff output',
    group = vim.api.nvim_create_augroup('ScratchDiff', { clear = true }),
    pattern = { 'jj://*', 'diff://*' },
    callback = function(ev)
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
      vim.bo.swapfile = false
      vim.bo.filetype = 'diff'
      configure_diff_keymaps(ev.buf)
    end,
  })

  vim.api.nvim_create_user_command('JjDiff', function(opts)
    open_jj_diff(opts.args)
  end, {
    desc = 'Open jj diff in a scratch buffer',
    nargs = '*',
  })

  vim.api.nvim_create_user_command('FileDiff', function(opts)
    if #opts.fargs ~= 2 then
      vim.notify('Usage: :FileDiff <file1> <file2>', vim.log.levels.ERROR)
      return
    end

    open_file_diff(vim.fn.fnamemodify(opts.fargs[1], ':p'), vim.fn.fnamemodify(opts.fargs[2], ':p'))
  end, {
    desc = 'Open a unified diff between two files in a scratch buffer',
    nargs = '+',
    complete = 'file',
  })
end

return M

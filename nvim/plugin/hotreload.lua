local function should_check()
  local mode = vim.api.nvim_get_mode().mode
  return not (
    mode:match '[cR!s]'
    or vim.fn.getcmdwintype() ~= ''
  )
end

local function should_reload_buffer(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
  local modified = vim.api.nvim_get_option_value('modified', { buf = buf })
  local is_real_file = name ~= '' and not name:match '^%w+://'

  return is_real_file and buftype == '' and not modified
end

-- Fallback: check on focus/enter events (catches edge cases like renames, new files)
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermLeave', 'BufEnter', 'WinEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('hotreload', { clear = true }),
  callback = function()
    if should_check() then
      vim.cmd 'checktime'
    end
  end,
})

-- Filesystem watchers: reload buffers immediately when files change on disk
local watchers = {}

local function watch_buffer(buf)
  if watchers[buf] then return end

  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' or path:match('^%w+://') then return end

  local handle = vim.uv.new_fs_event()
  if not handle then return end

  handle:start(path, {}, vim.schedule_wrap(function(err)
    if err then return end
    if vim.api.nvim_buf_is_valid(buf) and should_reload_buffer(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd('checktime')
      end)
    end
  end))

  watchers[buf] = handle
end

local function unwatch_buffer(buf)
  local handle = watchers[buf]
  if handle then
    handle:stop()
    handle:close()
    watchers[buf] = nil
  end
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('hotreload_watch', { clear = true }),
  callback = function(ev)
    watch_buffer(ev.buf)
  end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
  group = vim.api.nvim_create_augroup('hotreload_unwatch', { clear = true }),
  callback = function(ev)
    unwatch_buffer(ev.buf)
  end,
})

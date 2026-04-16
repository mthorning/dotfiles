vim.api.nvim_create_autocmd("BufReadPre", {
  desc = 'Fixes a tab issue when doing machete edit',
  group = vim.api.nvim_create_augroup('Machete', { clear = true }),
  pattern = '*.git/machete',
  callback = function()
    vim.opt.expandtab = false
  end
})

vim.api.nvim_create_autocmd("BufReadPre", {
  desc = 'Sets spell checking and wrapping on markdown files',
  group = vim.api.nvim_create_augroup('Markdown', { clear = true }),
  pattern = '*.md',
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = 'en_gb'
    vim.opt.wrap = true
  end
})

vim.api.nvim_create_autocmd("FileType", {
  desc = 'Sets spell checking and wrapping on markdown files (excluding floats)',
  group = vim.api.nvim_create_augroup('MarkdownFileType', { clear = true }),
  pattern = 'markdown',
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == '' then
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_gb'
      vim.opt_local.wrap = true
    end
  end
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = 'Binds Enter to :wq for zsh command-line editor temp files',
  group = vim.api.nvim_create_augroup('ZshCmdlineEdit', { clear = true }),
  pattern = '/private/tmp/*.zsh',
  callback = function()
    vim.keymap.set({'n', 'i'}, '<CR>', '<CMD>wq<CR>', { buffer = true })
  end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = 'Highlights yanked text',
  group = vim.api.nvim_create_augroup("HighlighOnYank", { clear = true}),
  callback = function()
    vim.highlight.on_yank { higroup='Visual', timeout=100 }
  end
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable built-in treesitter highlighting',
  group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP attach behavior',
  group = vim.api.nvim_create_augroup('LspAttachBehavior', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', 'grn', '<CMD>LspRename<CR>', { buffer = event.buf, desc = 'LSP: Rename' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePost' }, {
  desc = 'Configure scratch buffers used for jj diff output',
  group = vim.api.nvim_create_augroup('JjDiff', { clear = true }),
  pattern = 'jj://*',
  callback = function(ev)
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false
    vim.bo.filetype = 'diff'

    -- q to close the diff buffer (triggers BufWipeout → restores previous buffer)
    vim.keymap.set('n', 'q', '<CMD>bdelete<CR>', { buffer = ev.buf, desc = 'Close diff buffer' })

    -- buffer-local Pi keymaps (override globals, which-key picks these up)
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add({
        { '<leader>Ac', '<CMD>PiChatDiff<CR>',    buffer = ev.buf, mode = 'n', desc = 'Pi chat diff' },
        { '<leader>Ac', ':<C-u>PiChatDiff<CR>',    buffer = ev.buf, mode = 'v', desc = 'Pi chat diff' },
        { '<leader>An', '<CMD>PiChatDiffNew<CR>', buffer = ev.buf, mode = 'n', desc = 'Pi chat diff (new pane)' },
        { '<leader>An', ':<C-u>PiChatDiffNew<CR>', buffer = ev.buf, mode = 'v', desc = 'Pi chat diff (new pane)' },
        { '<leader>Aa', hidden = true,            buffer = ev.buf, mode = 'v' },
      })
    else
      vim.keymap.set('n', '<leader>Ac', '<CMD>PiChatDiff<CR>', { buffer = ev.buf, desc = 'Pi chat diff' })
      vim.keymap.set('v', '<leader>Ac', ':<C-u>PiChatDiff<CR>', { buffer = ev.buf, desc = 'Pi chat diff' })
      vim.keymap.set('n', '<leader>An', '<CMD>PiChatDiffNew<CR>', { buffer = ev.buf, desc = 'Pi chat diff (new pane)' })
      vim.keymap.set('v', '<leader>An', ':<C-u>PiChatDiffNew<CR>', { buffer = ev.buf, desc = 'Pi chat diff (new pane)' })
    end
  end,
})

vim.api.nvim_create_user_command('Conflicts', function()
  local cmd = vim.fn.executable('rg') == 1
      and "rg --vimgrep '<<<<<<<' 2>/dev/null"
      or "git grep -n '<<<<<<<' 2>/dev/null"

  local results = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #results == 0 then
    vim.notify('No conflicts found', vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, 'r', {
    title = 'Merge Conflicts',
    lines = results
  })
  vim.cmd('cfirst')
  vim.cmd('copen')
end, {
  desc = 'Find merge conflicts and open them in quickfix',
})

vim.api.nvim_create_user_command('JjDiff', function(opts)
  local diff_output = vim.fn.systemlist('jj diff ' .. opts.args)
  if vim.v.shell_error ~= 0 or #diff_output == 0 or (#diff_output == 1 and diff_output[1] == '') then
    vim.notify('No changes to show', vim.log.levels.INFO)
    -- If the current buffer is empty (e.g. launched via `nvim +JjDiff`), show alpha
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) == '' and vim.api.nvim_buf_line_count(buf) <= 1 then
      local ok, alpha = pcall(require, 'alpha')
      if ok then
        alpha.start(false)
      end
    end
    return
  end

  local prev_buf = vim.api.nvim_get_current_buf()
  vim.cmd('enew')
  vim.cmd('file jj://diff')
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, diff_output)
  vim.b.jj_diff_args = opts.args  -- store for later use by PiChatDiff
  vim.bo.modifiable = false

  -- File watcher: re-run jj diff when files in cwd change
  local fs_handle = vim.uv.new_fs_event()
  local debounce_timer = vim.uv.new_timer()

  local function refresh_diff()
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local new_output = vim.fn.systemlist('jj diff ' .. (vim.b[buf].jj_diff_args or ''))
    if vim.v.shell_error ~= 0 then return end
    -- Save and restore cursor position
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
      if err then return end
      -- Debounce: wait 200ms after last change before refreshing
      debounce_timer:stop()
      debounce_timer:start(200, 0, vim.schedule_wrap(refresh_diff))
    end))
  end

  -- Restore previous buffer when the diff buffer is closed
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buf,
    callback = function()
      -- Clean up file watcher
      if debounce_timer then
        debounce_timer:stop()
        debounce_timer:close()
      end
      if fs_handle then
        fs_handle:stop()
        fs_handle:close()
      end

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
    end,
  })
end, {
  desc = 'Open jj diff in a scratch buffer',
  nargs = '*',
})

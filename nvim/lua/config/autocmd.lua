vim.api.nvim_create_autocmd("BufReadPre", {
  desc = 'Fixes a tab issue when doing machete edit',
  group = vim.api.nvim_create_augroup('Machete', { clear = true }),
  pattern = '*.git/machete',
  callback = function()
    vim.opt.expandtab = false
  end
})

--[[ vim.api.nvim_create_autocmd("BufReadPre", {
  desc = 'Makes the help screen open in vertical split to the right',
  group = vim.api.nvim_create_augroup('Help', { clear = true }),
  pattern = '*.txt',
  callback = function()
    if vim.bo.buftype == 'help' then
      vim.cmd('wincmd L')
    end
  end
}) ]]

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
  callback = function()
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false
    vim.bo.filetype = 'diff'
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
  vim.cmd('enew')
  vim.cmd('file jj://diff')
  vim.cmd('read !jj diff ' .. opts.args)
  vim.cmd('1delete')
end, {
  desc = 'Open jj diff in a scratch buffer',
  nargs = '*',
})

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

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = 'Highlights yanked text',
  group = vim.api.nvim_create_augroup("HighlighOnYank", { clear = true}),
  callback = function()
    vim.highlight.on_yank { higroup='Visual', timeout=100 }
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = 'LSP keymaps',
  group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "grn", "<CMD>LspRename<CR>", { buffer = event.buf, desc = "LSP: Rename" })
  end
})

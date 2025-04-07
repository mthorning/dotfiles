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

vim.cmd("autocmd FileType markdown setlocal spell spelllang=en_gb wrap")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = 'Highlights yanked text',
  group = vim.api.nvim_create_augroup("HighlighOnYank", { clear = true}),
  callback = function()
    vim.highlight.on_yank { higroup='Visual', timeout=100 }
  end
})

-- Ensure format on save works for JS/TS files
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = 'Format TypeScript/JavaScript files on save',
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true}),
  pattern = {"*.ts", "*.tsx", "*.js", "*.jsx"},
  callback = function()
    vim.cmd("silent call CocAction('format')")
  end
})

-- Specifically for TypeScriptReact files
vim.cmd([[
  augroup TSXFormatting
    autocmd!
    autocmd FileType typescriptreact autocmd BufWritePre <buffer> silent! call CocAction('format')
  augroup END
]])

-- Specifically for JavaScript and TypeScript files
vim.cmd([[
  augroup JSFormatting
    autocmd!
    autocmd FileType javascript,typescript,javascriptreact autocmd BufWritePre <buffer> silent! call CocAction('format')
  augroup END
]])

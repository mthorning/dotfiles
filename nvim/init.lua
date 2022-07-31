require 'plugins'
require 'lsp'
require 'keymappings'

vim.opt.sw = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmode = false
vim.opt.mouse = 'a'
vim.opt.iskeyword = vim.opt.iskeyword:append('-')
vim.opt.undodir = '$HOME/.vim/undodir'
vim.opt.undofile = true
vim.opt.timeoutlen = 0
vim.opt.signcolumn = 'yes'
vim.opt.syntax = 'on'

vim.cmd([[
  let g:tokyonight_italic_functions=1
  let g:tokyonight_italic_keywords=0
  colorscheme tokyonight

  let lazygit_floating_window_use_plenary=1
]])

vim.cmd("autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif")

vim.cmd("autocmd FileType markdown setlocal spell spelllang=en_gb wrap")
vim.cmd("autocmd FileType go setlocal sw=8")

vim.cmd("command! LspInstallAll :call LspInstallAll()")


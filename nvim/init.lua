require 'plugins'
require 'lsp'
require 'keymappings'

vim.cmd([[
  set sw=2
  set expandtab
  set autoindent
  set smartindent
  set number relativenumber
  set nu rnu
  set scrolloff=4
  set nowrap
  set splitright
  set splitbelow
  set nohlsearch
  set incsearch
  set whichwrap+=<,>,[,]
  set noshowmode
  set mouse=a
  set iskeyword+=-
  set undodir=$HOME/.vim/undodir
  set undofile
  set timeoutlen=500
  set signcolumn=yes
  syntax on
  colorscheme tokyonight
  let lazygit_floating_window_use_plenary=1
]])

vim.cmd("autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif")

vim.cmd("command! LspInstallAll :call LspInstallAll()")

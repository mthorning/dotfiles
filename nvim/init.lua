require 'install_plugins'
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
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.timeoutlen = 0
vim.opt.signcolumn = 'yes'
vim.opt.syntax = 'on'

vim.g.lazygit_floating_window_use_plenary = 1
vim.g.illuminate_highlightUnderCursor = 0

vim.g.neomux_start_term_map = '<Leader>t.'
vim.g.neomux_exit_term_mode_map = '<C-space>'
vim.g.neomux_start_term_split_map = '<Leader>ts'
vim.g.neomux_start_term_vsplit_map = '<Leader>tv'
vim.g.neomux_no_term_autoinsert = 1

vim.cmd("autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif")
vim.cmd("autocmd FileType markdown setlocal spell spelllang=en_gb wrap")

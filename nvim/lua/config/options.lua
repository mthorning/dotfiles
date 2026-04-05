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
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.timeoutlen = 0
vim.opt.signcolumn = 'yes'

vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.clipboard = 'unnamedplus'
vim.g.rust_recommended_style = 0
vim.opt.laststatus = 3

vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false
vim.opt.foldlevel  = 99

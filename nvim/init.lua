for _, conf in pairs {
    'plugins', 'plug-conf.nvim-tree', 'plug-conf.which-key',
    'plug-conf.telescope', 'plug-conf.treesitter', 'plug-conf.galaxyline',
    'plug-conf.neomux', 'plug-conf.alpha', 'plug-conf.lspsaga', 'plug-conf.cmp',
    'plug-conf.session-manager', 'plug-conf.neoscroll', 'plug-conf.autopairs',
    'plug-conf.gitsigns', 'lsp', 'keymappings'
} do require(conf) end

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

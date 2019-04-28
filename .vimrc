call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'benmills/vimux'

call plug#end()

syntax on
colorscheme dracula
set number
set laststatus=2 "for the status bar to work
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"Mappings
inoremap kj <esc>
cnoremap kj <C-C>
nnoremap <F4> :NERDTreeToggle<CR>  

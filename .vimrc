call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'benmills/vimux'
Plug 'https://github.com/pangloss/vim-javascript.git'
Plug 'w0rp/ale'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

call plug#end()

syntax on
colorscheme dracula
set number

set laststatus=2 "for the status bar to work
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"Mappings
let mapleader=","
inoremap kj <esc>
cnoremap kj <C-C>
vnoremap kj <esc>
nnoremap <F4> :NERDTreeToggle<CR>  
map <Leader>vp :VimuxPromptCommand<CR>

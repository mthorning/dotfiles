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
Plug 'https://github.com/mxw/vim-jsx.git'

call plug#end()

let g:rustfmt_autosave = 1
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

syntax on
colorscheme dracula
set number

set laststatus=2 "for the status bar to work
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

"Mappings
let mapleader=","
inoremap kj <esc>
cnoremap kj <C-C>
vnoremap kj <esc>
nnoremap <F4> :NERDTreeToggle<CR>  
map <Leader>vp :VimuxPromptCommand<CR>

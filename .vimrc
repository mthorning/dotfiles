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
Plug 'https://github.com/vim-syntastic/syntastic.git'
Plug 'https://github.com/wagnerf42/vim-clippy.git'
Plug 'https://tpope.io/vim/surround.git'
Plug 'https://tpope.io/vim/repeat.git'
Plug 'https://tpope.io/vim/commentary.git'
Plug 'Yggdroot/indentLine'
Plug 'michaeljsmith/vim-indent-object'
Plug 'racer-rust/vim-racer'
Plug 'neomake/neomake'


call plug#end()

let g:rustfmt_autosave = 1
let g:prettier#autoformat = 0
let g:syntastic_rust_checkers = ['clippy']
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

syntax on
colorscheme dracula
set shiftwidth=4
set number relativenumber 
set mouse=a
set laststatus=2 "for the status bar to work

let g:lightline = {
\        'active': {
\	  'left': [ [ 'mode', 'paste' ],
\	      [ 'readonly', 'foldername', 'filename', 'modified' ] ]
\        },
\        'component_function': {
\            'foldername': 'FolderForLightline'
\        },
\    }

" Show full path of filename
function! FolderForLightline()
      let path = split(expand('%:p:h'), '/')
      return path[-1]
endfunction

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
map <leader>vp :VimuxPromptCommand<CR>
map <leader>m :VimuxRunCommand("cargo run")<CR>
map <leader>. :VimuxRunCommand("cargo test")<CR>

set splitbelow splitright

set hidden
let g:racer_cmd = "$HOME/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1
au FileType rust nmap <leader>rg <Plug>(rust-def-vertical)
au FileType rust nmap <leader>rd <Plug>(rust-doc)

call neomake#configure#automake('nrwi', 500)

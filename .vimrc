"		       _                    
"		__   _(_)_ __ ___  _ __ ___ 
"		\ \ / / | '_ ` _ \| '__/ __|
"		 \ V /| | | | | | | | | (__ 
"		(_)_/ |_|_| |_| |_|_|  \___|
"		                            


call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'benmills/vimux'
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
Plug 'airblade/vim-gitgutter'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'alvan/vim-closetag'

call plug#end()

"Some basics
set spelllang=en
syntax on
colorscheme dracula
set shiftwidth=4
set number relativenumber 
set mouse=a
set splitbelow splitright
set hidden
set scrolloff=5
au FileType gitcommit 1 | startinsert

"Rust
let g:rustfmt_autosave = 1
let g:syntastic_rust_checkers = ['clippy']
au FileType rust nmap <leader>rg <Plug>(rust-def-vertical)
au FileType rust nmap <leader>rd <Plug>(rust-doc)

"Javascript
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
let g:neomake_javascript_enabled_makers = ['eslint']
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

"Plugin settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

let g:racer_cmd = "$HOME/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

let g:markdown_fenced_languages = ['html', 'jsx', 'javascript', 'bash=sh']
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx"

call neomake#configure#automake('nrwi', 500)

"Mappings
let mapleader=","
inoremap kj <esc>
cnoremap kj <C-c>
vnoremap kj <esc>
nnoremap <esc> :noh<CR><esc>
nnoremap <F4> :NERDTreeToggle<CR>  
map <leader>vp :VimuxPromptCommand<CR>
map <leader>m :VimuxRunCommand("cargo run")<CR>
map <leader>. :VimuxRunCommand("cargo test")<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"NerdTree
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

"Status line
let g:lightline = {
\        'active': {
\	  'left': [ [ 'mode', 'paste' ],
\	      [ 'readonly', 'foldername', 'filename', 'modified' ] ]
\        },
\        'component_function': {
\            'foldername': 'FolderForLightline'
\        },
\    }

function! FolderForLightline()
      let path = split(expand('%:p:h'), '/')
      return path[-1]
endfunction
set laststatus=2 "for the status bar to work

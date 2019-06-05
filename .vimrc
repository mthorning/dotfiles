"		       _                    
"		__   _(_)_ __ ___  _ __ ___ 
"		\ \ / / | '_ ` _ \| '__/ __|
"		 \ V /| | | | | | | | | (__ 
"		(_)_/ |_|_| |_| |_|_|  \___|
"		                            


"Mappings
let mapleader=","
inoremap kj <esc>
cnoremap kj <C-c>
vnoremap kj <esc>
nnoremap <esc> :noh<CR><esc>
nnoremap <F4> :NERDTreeToggle<CR>  

" RACER autocomplete = C-x-C-o

nnoremap <C-p> :FZF<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <leader>vp :VimuxPromptCommand<CR>
map <leader>conf :tabe ~/dotfiles/.vimrc<CR>
map <leader>w :w<CR>
map <leader># :b#<CR>

au FileType rust nmap <leader>gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
au FileType rust nmap <leader>m :VimuxRunCommand("cargo run")<CR>
au FileType rust nmap <leader>. :VimuxRunCommand("cargo test")<CR>

"Plugins
call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
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
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

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

"turn off auto-comment next line:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"Rust
let g:rustfmt_autosave = 1
let g:syntastic_rust_checkers = ['clippy']
let g:racer_experimental_completer = 1

"Javascript
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
let g:neomake_javascript_enabled_makers = ['eslint']
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

"Plugin settings
let g:racer_cmd = "$HOME/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

let g:markdown_fenced_languages = ['html', 'jsx', 'javascript', 'bash=sh']
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx"

call neomake#configure#automake('nrwi', 500)

let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

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


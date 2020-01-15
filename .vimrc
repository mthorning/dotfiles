"		       _                    

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


nnoremap <C-p> :FZF<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <leader>vp :VimuxPromptCommand<CR>
map <leader>conf :tabe ~/dotfiles/.vimrc<CR>
map <leader><ESC> :Startify<CR>
map <leader>w :w<CR>
map <leader>a :wa<CR>
map <leader># :b#<CR>
map <leader>l :ALEToggle<CR>
"prettify json: 
map <leader>j :%!python -m json.tool<CR>
map <leader>f :CtrlSF<SPACE>
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"Some basics
set spelllang=en
set shiftwidth=4
set number relativenumber 
set mouse=a
set splitbelow splitright
set hidden
set scrolloff=5
set nopaste
set expandtab
au FileType gitcommit 1 | startinsert

"Plugins
call plug#begin('~/.vim/plugged')

 Plug 'https://github.com/scrooloose/nerdtree.git'
 Plug 'Xuyuanp/nerdtree-git-plugin'
 Plug 'itchyny/lightline.vim'
 Plug 'mhinz/vim-startify'
 Plug 'benmills/vimux'
 Plug 'https://github.com/pangloss/vim-javascript.git'
 Plug 'https://github.com/wagnerf42/vim-clippy.git'
 Plug 'https://tpope.io/vim/surround.git'
 Plug 'https://tpope.io/vim/repeat.git'
 Plug 'https://tpope.io/vim/commentary.git'
 Plug 'Yggdroot/indentLine'
 Plug 'michaeljsmith/vim-indent-object'
 Plug 'airblade/vim-gitgutter'
 Plug 'https://github.com/tpope/vim-fugitive.git'
 Plug 'alvan/vim-closetag'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'
 Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
 Plug 'https://github.com/b4winckler/vim-angry.git'
 Plug 'dracula/vim', { 'as': 'dracula' }
 Plug 'luochen1990/rainbow'
 Plug 'jelera/vim-javascript-syntax'
 Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
 Plug 'https://github.com/ternjs/tern_for_vim.git'
 Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
 Plug 'https://github.com/mxw/vim-jsx.git'
 Plug 'maxmellon/vim-jsx-pretty'
 Plug 'evanleck/vim-svelte'
 Plug 'https://github.com/jxnblk/vim-mdx-js.git'
 Plug 'reasonml-editor/vim-reason-plus'
 Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
 Plug 'w0rp/ale'
 Plug 'dyng/ctrlsf.vim'

call plug#end()

map <leader>def :ALEGoToDefinition<CR>
nnoremap <F4> :NERDTreeToggle<CR>  
au FileType rust nmap <leader>gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
au FileType rust nmap <leader>m :VimuxRunCommand("cargo run")<CR>
au FileType rust nmap <leader>. :VimuxRunCommand("cargo test")<CR>
au FileType javascript nmap <leader>. :VimuxRunCommand("npm test")<CR>

"turn off auto-comment next line:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:markdown_fenced_languages = ['html', 'jsx', 'javascript', 'bash=sh']
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.svelte"

let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

let g:rainbow_active = 1

let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
let g:ale_fixers = {
\   'svelte': ['prettier'],
\   'javascript': ['prettier'],
\   'reason': ['refmt'],
\   'css': ['prettier'],
\   'rust': ['rustfmt'],
\}
let g:ale_linters = {
\   'svelte': ['eslint'],
\   'reason': ['reason-language-server'],
\   'rust': ['rls'],
\}
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', '~/.cargo/bin/rls'],
    \ 'reason': ['~/reason-language-server'],
    \ }


let g:deoplete#enable_at_startup = 1
set completeopt-=preview
set runtimepath+=~/home/mthorning/.vim/plugged/deoplete.nvim
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#guess = 0
let g:deoplete#sources#ternjs#filetypes = [
\ 'jsx',
\ 'javascript.jsx',
\ 'vue',
\ 'svelte'
\ ]

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
\	'colorscheme': 'darcula',
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

syntax enable
set termguicolors
let g:dracula_colorterm = 0
let g:dracula_italic = 1
colorscheme dracula


" let g:reasonml_refmt_executable = '~/.nvm/versions/node/v12.13.1/bin/refmt'
" let g:ale_reason_ls_executable = '~/reason-language-server'

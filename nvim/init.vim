"                      _
"               \ \ / / | '_ ` _ \| '__/ __|
"                \ V /| | | | | | | | | (__
"               (_)_/ |_|_| |_| |_|_|  \___|
"


"Mappings
let mapleader=","
nnoremap <esc> :noh<CR><esc>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nmap <CR> o<Esc>k

map <leader>vp :VimuxPromptCommand<CR>
map <leader>conf :tabe ~/dotfiles/nvim/init.vim<CR>
map <leader>w :w<CR>
map <leader>a :wa<CR>
map <leader># :b#<CR>
map <leader>j :%!python -m json.tool<CR>
map <leader>t :vsp term://zsh<CR>

map <leader>s :mks! ~/current-session.vim<CR>
map <leader>cd :lcd %:h<CR>

set mouse=a

nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

inoremap <C-p> <Nop>
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

let g:clipboard = {
  \   'name': 'WslClipboard',
  \   'copy': {
  \      '+': 'clip.exe',
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \   },
  \   'cache_enabled': 0,
  \ }


"Plugins
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()

Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
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
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'https://github.com/b4winckler/vim-angry.git' "args text object
Plug 'luochen1990/rainbow'
Plug 'dracula/vim', { 'as': 'dracula' },
Plug 'jelera/vim-javascript-syntax'
Plug 'https://github.com/mxw/vim-jsx.git'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'evanleck/vim-svelte'
Plug 'https://github.com/jxnblk/vim-mdx-js.git'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'dyng/ctrlsf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'cloudhead/neovim-fuzzy'
Plug 'psliwka/vim-smoothie'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'amiralies/vim-rescript'
Plug 'brooth/far.vim'
Plug 'fatih/vim-go'
Plug 'andymass/vim-matchup'

call plug#end()

nnoremap <C-p> :FuzzyOpen<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<cr>
map <leader>f :CtrlSF<SPACE>

"turn off auto-comment next line:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:markdown_fenced_languages = ['html', 'jsx', 'javascript', 'bash=sh']
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.svelte"

let g:sneak#label = 1

let g:rainbow_active = 1

let g:LanguageClient_serverCommands = {
            \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', '~/.cargo/bin/rls'],
            \ 'reason': ['~/reason-language-server'],
            \ }


"NerdTree
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
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
\    'colorscheme': 'darcula',
\    'active': {
\     'left': [ [ 'mode', 'paste' ],
\         [ 'readonly', 'cwd', 'filename', 'modified' ] ]
\    },
\    'component_function': {
\        'cwd': 'Cwd',
\        'filename': 'FilenameForLightline',
\    },
\    'mode_map': {
\        'n' : 'N',
\        'i' : 'I',
\        'R' : 'R',
\        'v' : 'V',
\        'V' : 'VL',
\        "\<C-v>": 'VB',
\        'c' : 'C',
\        's' : 'S',
\        'S' : 'SL',
\        "\<C-s>": 'SB',
\        't': 'T',
\     } 
\  }

function! FilenameForLightline()
    let path = split(expand("%:p:h"), "/")
    return path[-1] . "/" . expand("%:t")
endfunction

function! Cwd()
    return getcwd()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
set laststatus=2 "for the status bar to work

syntax enable
set termguicolors
let g:dracula_colorterm = 0
let g:dracula_italic = 1
colorscheme dracula

" Fuzzy searching
set wildmenu
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*:
set viminfo='100,n$HOME/.vim/files/info/viminfo

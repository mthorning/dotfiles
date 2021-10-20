if vim.fn.has('nvim') and vim.fn.executable('nvr') then
  vim.fn.setenv('GIT_EDITOR',  "nvr -cc vsplit --remote-wait +'set bufhidden=wipe'")
end

vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set inccommand=split') -- Make substitution work in realtime
vim.o.hidden = O.hidden_files -- Required to keep multiple buffers open multiple buffers

vim.o.title = true
vim.o.titlestring="%<%F%=%l/%L - nvim"

TERMINAL = vim.fn.expand('$TERMINAL')
vim.cmd('let &titleold="'..TERMINAL..'"')
vim.wo.wrap = O.wrap_lines -- Display long lines as just one line
vim.cmd('set whichwrap+=<,>,[,]') -- move to next line with theses keys
vim.cmd('syntax on') -- syntax highlighting
vim.o.pumheight = 10 -- Makes popup menu smaller
vim.o.fileencoding = "utf-8" -- The encoding written to file
vim.o.cmdheight = 1 -- More space for displaying messages
vim.cmd('set colorcolumn=99999') -- fix indentline for now
vim.o.mouse = "a" -- Enable your mouse
vim.o.splitbelow = true -- Horizontal splits will automatically be below
vim.o.termguicolors = true -- set term gui colors most terminals support this
vim.o.splitright = true -- Vertical splits will automatically be to the right
vim.go.t_Co = "256" -- Support 256 colors
vim.o.conceallevel = 0 -- So that I can see `` in markdown files

vim.o.swapfile = true
vim.o.undodir = vim.fn.expand('$HOME/.vim/undodir')
vim.o.undofile = true
vim.o.backup = false -- This is recommended by coc
vim.o.writebackup = false -- This is recommended by coc

vim.bo.tabstop = 4 -- tabs are at proper location
vim.bo.expandtab = true -- don't use actual tab character (ctrl-v)
vim.bo.shiftwidth = 4 -- indenting is 4 spaces

vim.wo.number = O.number -- set numbered lines
vim.wo.relativenumber = O.relative_number -- set relative number
vim.wo.cursorline = false -- Enable highlighting of the current line
vim.o.showtabline = 2 -- Always show tabs
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore
vim.wo.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.updatetime = 300 -- Faster completion
vim.o.timeoutlen = O.timeoutlen -- By default timeoutlen is 1000 ms
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.scrolloff = 4

vim.o.updatetime = 50

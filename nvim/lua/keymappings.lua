local opts = {noremap = true, silent = true}

local set = function(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, opts)
end

set("n", "<SPACE>", "<Nop>")
vim.cmd("let mapleader=' '")

-- better window movement
set("n", "<C-h>", "<C-w>h")
set("n", "<C-j>", "<C-w>j")
set("n", "<C-k>", "<C-w>k")
set("n", "<C-l>", "<C-w>l")

-- resize with arrows
set("n", "<C-Up>", ":resize +2<CR>")
set("n", "<C-Down>", ":resize -2<CR>")
set("n", "<C-Left>", ":vertical resize +2<CR>")
set("n", "<C-Right>", ":vertical resize -2<CR>")

-- Tab switch
set("n", "<TAB>", "gt")
set("n", "<S-TAB>", "gT")

-- Move selected line / block of text in visual mode
set("x", "J", ":move \">+1<CR>gv-gv")
set("x", "K", ":move \"<-2<CR>gv-gv")

-- better indenting in visual mode
set("v", "<", "<gv")
set("v", ">", ">gv")

-- Yank end of line
set("n", "Y", "y$$")

-- Keeping it centered
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")
set("n", "J", "mzJ`z")

-- LSP
set("n", "<C-n>", "<cmd>Lspsaga diagnostic_jump_next<cr>")
set("n", "<C-p>", "<cmd>Lspsaga diagnostic_jump_prev<cr>")

set("n", "<C-b>",
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")

set("n", "<C-f>",
    "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")

-- Add new lines
set("n", "<CR>", "o<Esc>k")
set("n", "<S-CR>", "O<Esc>j")


local opts = {noremap = true, silent = true}

local set = function(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, opts)
end

set("n", "<SPACE>", "<Nop>")
vim.g.mapleader = " "

-- better window movement
set("n", "<C-h>", "<C-w>h")
set("n", "<C-j>", "<C-w>j")
set("n", "<C-k>", "<C-w>k")
set("n", "<C-l>", "<C-w>l")

-- same for terminals
set("t", "<C-h>", [[<C-\><C-N><C-w>h"]])
set("t", "<C-j>", [[<C-\><C-N><C-w>j"]])
set("t", "<C-k>", [[<C-\><C-N><C-w>k"]])
set("t", "<C-l>", [[<C-\><C-N><C-w>l"]])

-- resize with arrows
set("n", "<S-Up>", ":resize +2<CR>")
set("n", "<S-Down>", ":resize -2<CR>")
set("n", "<S-Left>", ":vertical resize -2<CR>")
set("n", "<S-Right>", ":vertical resize +2<CR>")

-- Tab switch
set("n", "<Leader><TAB>", "gt")
set("n", "<Leader><S-TAB>", "gT")
-- Move selected line / block of text in visual mode
set("v", "<C-j>", ":m '>+1<CR>gv=gv")
set("v", "<C-k>", ":m '<-2<CR>gv=gv")

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
set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<cr>")
set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

-- Remove annoying weird keybinding
set("i", "<", "<")

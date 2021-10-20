vim.api.nvim_set_keymap('n', '-', ':RnvimrToggle<CR>', {noremap = true, silent = true})


-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- resize with arrows
vim.cmd([[
  nnoremap <silent> <C-Up>    :resize +2<CR>
  nnoremap <silent> <C-Down>  :resize -2<CR>
  nnoremap <silent> <C-Left>  :vertical resize +2<CR>
  nnoremap <silent> <C-Right> :vertical resize -2<CR>
]])

-- Tab switch
vim.api.nvim_set_keymap('n', '<TAB>', 'gt', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', 'gT', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})

-- better indenting in visual mode
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- Yank end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$$', {noremap = true, silent = true})

-- Keeping it centered
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', {noremap = true, silent = true})



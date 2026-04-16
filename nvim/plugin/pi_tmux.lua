if vim.g.loaded_pi_tmux then
  return
end
vim.g.loaded_pi_tmux = true

vim.api.nvim_create_user_command('PiChatHere', function()
  require('pi_tmux').chat()
end, { desc = 'Open pi chat with current file and cursor context' })

vim.api.nvim_create_user_command('PiChatSelection', function()
  require('pi_tmux').chat_selection()
end, { range = true, desc = 'Open pi chat with visual selection context' })

vim.api.nvim_create_user_command('PiApplySelection', function()
  require('pi_tmux').apply_selection()
end, { range = true, desc = 'Apply a quick pi change to the current selection' })

vim.api.nvim_create_user_command('PiNewPane', function()
  require('pi_tmux').chat_new_selection()
end, { range = true, desc = 'Open pi chat in a fresh tmux pane with visual selection context' })

vim.api.nvim_create_user_command('PiChatDiff', function()
  require('pi_tmux').chat_diff()
end, { range = true, desc = 'Chat with Pi about a jj diff selection or hunk' })

vim.api.nvim_create_user_command('PiChatDiffNew', function()
  require('pi_tmux').chat_diff_new()
end, { range = true, desc = 'Chat with Pi about a jj diff in a new pane' })

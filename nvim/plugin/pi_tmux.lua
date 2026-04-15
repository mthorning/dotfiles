if vim.g.loaded_pi_tmux then
  return
end
vim.g.loaded_pi_tmux = true

vim.api.nvim_create_user_command('PiChatSelection', function()
  require('pi_tmux').chat_selection()
end, { range = true, desc = 'Open pi chat with visual selection context' })

vim.api.nvim_create_user_command('PiApplySelection', function()
  require('pi_tmux').apply_selection()
end, { range = true, desc = 'Apply a quick pi change to the current selection' })

vim.api.nvim_create_user_command('PiNewPane', function()
  require('pi_tmux').chat_new_selection()
end, { range = true, desc = 'Open pi chat in a fresh tmux pane with visual selection context' })

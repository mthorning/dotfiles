-- Aider.lua - Plugin to open aider with the current file
-- Author: User
-- Version: 1.0.0

local M = {}

-- Function to get the current file path
local function get_current_file_path()
  return vim.fn.expand('%:p')
end

-- Function to open a vertical terminal and run aider with the file path
local function open_aider_with_file()
  local file_path = get_current_file_path()

  -- Yank the file path to the unnamed register
  vim.fn.setreg('"', file_path)

  -- Notify the user
  vim.notify('File path yanked: ' .. file_path, vim.log.levels.INFO)

  -- Open a vertical terminal split
  vim.cmd('vsplit')
  vim.cmd('terminal aider ' .. vim.fn.shellescape(file_path))

  -- Enter insert mode to interact with the terminal
  vim.cmd('startinsert')
end

-- Create a command to run the function
vim.api.nvim_create_user_command('AiderCurrentFile', open_aider_with_file, {
  desc = 'Open aider with the current file in a vertical terminal split'
})

return M

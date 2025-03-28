local M = {}

local function get_current_file_path()
  return vim.fn.expand('%:p')
end

local function open_aider_with_file()
  local file_path = get_current_file_path()

  vim.fn.setreg('"', file_path)

  vim.notify('File path yanked: ' .. file_path, vim.log.levels.INFO)

  vim.cmd('vsplit')
  vim.cmd('terminal aider ' .. vim.fn.shellescape(file_path))

  vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('AiderCurrentFile', open_aider_with_file, {
  desc = 'Open aider with the current file in a vertical terminal split'
})

return M

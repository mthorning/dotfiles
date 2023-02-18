local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local tms = function(opts)
  pickers.new(opts, {
    prompt_title = 'Find Directory',
    finder = finders.new_oneshot_job({
      'find',
      '-L',
      vim.fn.expand('$HOME'),
      vim.fn.expand('$HOME/code'),
      vim.fn.expand('$HOME/server/apps'),
      '-type', 'd',
      '-maxdepth', '1'
    }, opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection ~= nil then
          actions.close(prompt_bufnr)
          os.execute(vim.fn.expand('$HOME/.local/bin/tmux-sessioniser' .. ' ' .. selection[1]))
        end
      end)
      return true
    end,
  }):find()
end

return require('telescope').register_extension {
  setup = function(ext_config, config)
  end,
  exports = {
    tmux_sessionizer = tms
  },
}

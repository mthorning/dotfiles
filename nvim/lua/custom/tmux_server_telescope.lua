local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Name",
    finder = finders.new_table {
      fn_command = function()
        return
        "find -L ~ ~/server/apps ~/code -path ~/.Trash -prune -o -type d -maxdepth 2 -print | fzf"
      end,
      entry_maker = function(entry)
        return { value = entry, display = entry[1], ordinal = entry[1] }
      end
    },
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end
  }):find()
end

colors(require("telescope.themes").get_dropdown {})

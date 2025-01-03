return {
  "mikavilpas/yazi.nvim",
  lazy = false,
  keys = {},
  keymaps = {},
  opts = {
    use_ya_for_events_reading = true,
    use_yazi_client_id_flag = true,
    open_multiple_tabs = true,
    open_for_directories = true,
    floating_window_scaling_factor = {
      width = 0.95,
      height = 0.95,
    },
    -- log_level = vim.log.levels.DEBUG,
    integrations = {
      grep_in_directory = function(directory)
        require("my-nvim-micro-plugins.main").my_live_grep({ cwd = directory })
      end,
    },
    future_features = {
      ya_emit_reveal = true,
    },
    keymaps = {
      show_help = 'g?',
    },
  },
}

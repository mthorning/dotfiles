return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = false },
    lazygit = { enabled = true },
    dashboard = {
      width = 40,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰈙 ", key = "e", desc = "Explorer", action = ":lua require'oil'.open_float()" },
          { icon = "", key = "g", desc = "Git", action = ":lua Snacks.lazygit()", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "p", desc = "Plugins", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        },
      },
      sections = {
        { section = "keys",   gap = 1, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
          pane = 2,
        },
        {
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          ttl = 5 * 60,
          indent = 3,
          padding = 1,
          height = 5,
          pane = 2,
        },
        {
          icon = " ",
          title = "Machete Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root()
          end,
          cmd = "git machete status",
          ttl = 5 * 60,
          indent = 3,
          padding = 1,
          height = 5,
          pane = 2,
        },
        { section = "startup" },
      },
    },
  }
}

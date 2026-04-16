return {
  { 'nvim-tree/nvim-web-devicons',    event = 'VeryLazy' },
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy' },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Replaces dressing.nvim: prettier vim.ui.input
      input    = { enabled = true },
      -- Nice vim.notify popups
      notifier = { enabled = true },
      -- Faster startup when opening a file from CLI
      quickfile = { enabled = true },
      -- Cleaner statuscolumn (signs + folds + line numbers)
      statuscolumn = { enabled = true },
      -- Highlight other occurrences of word under cursor (like vim-illuminate)
      words    = { enabled = true },
      -- Subtle indent guides
      indent   = { enabled = true },
    },
  },
  { 'NvChad/nvim-colorizer.lua',      event = 'VeryLazy' },
  { 'b3nj5m1n/kommentary',            event = 'VeryLazy' },

  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    config = function() require 'neoscroll'.setup() end
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function() require 'gitsigns'.setup() end,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'prettier/vim-prettier',
    lazy = false,
    config = function()
      vim.g['prettier#exec_cmd_async'] = 1
      vim.g['prettier#quickfix_enabled'] = 0
    end
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "<author> • <date>",
      date_format = "%Y-%m-%d",
      virtual_text_column = 1,
    },
  },
}

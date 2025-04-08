return {
  { 'nvim-tree/nvim-web-devicons',    event = 'VeryLazy' },
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy' },
  { 'NvChad/nvim-colorizer.lua',      event = 'VeryLazy' },
  { 'b3nj5m1n/kommentary',            event = 'VeryLazy' },
  { 'RRethy/vim-illuminate',          event = 'VeryLazy' },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-moon]])

      vim.g.tokyonight_italic_functions = 1
      vim.g.tokyonight_italic_keywords = 0
    end
  },
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
  { 'ThePrimeagen/harpoon', event = 'VeryLazy', dependencies = 'nvim-lua/plenary.nvim' },
  { 'mbbill/undotree',      event = 'VeryLazy' },
  {
    'prettier/vim-prettier',
    lazy = false,
    config = function()
      vim.g['prettier#exec_cmd_async'] = 1
      vim.g['prettier#quickfix_enabled'] = 0
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = function() require 'colorizer'.setup() end
  },
  {
    'windwp/nvim-autopairs',
    event = "VeryLazy",
    config = true,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
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
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set('i', '<Up>', 'copilot#Previous()', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Down>', 'copilot#Next()', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Right>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Left>', 'copilot#Dismiss()', {
        expr = true,
        replace_keycodes = false
      })


      vim.g.copilot_no_tab_map = true
    end
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

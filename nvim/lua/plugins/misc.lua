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
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    event = 'VeryLazy',
    config = function()
      require 'zen-mode'.setup()
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
    "mikavilpas/yazi.nvim",
    enabled = false,
    lazy = false,
    keys = {},
    keymaps = {},
    commit = "14ba86dbfa97361428ef2413f0cb207e968cc58e",
    opts = {
      open_for_directories = true,
    },
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  { 'f-person/git-blame.nvim', event = 'VeryLazy' },
}

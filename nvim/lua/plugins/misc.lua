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
  { 'ThePrimeagen/harpoon',  event = 'VeryLazy', dependencies = 'nvim-lua/plenary.nvim' },
  { 'mbbill/undotree',       event = 'VeryLazy' },
  { 'prettier/vim-prettier', event = 'VeryLazy' },
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
  { 'f-person/git-blame.nvim', event = 'VeryLazy' },
}

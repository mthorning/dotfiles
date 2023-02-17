local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function() require 'configs.which_key' end
  }, {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      plugins = {
        tmux = { enabled = true },
        kitty = { enabled = true, font = "+4" }
      }
    })
  end
}, {
  'neovim/nvim-lspconfig',
  event = 'VimEnter',
  config = function() require 'configs.lsp_config' end
}, {
  'tami5/lspsaga.nvim',
  event = 'VimEnter',
  config = function() require 'configs.lsp_saga' end
}, {
  'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  config = function() require 'configs.treesitter' end,
  build = ':TSUpdate'
}, {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  config = function() require 'configs.treesitter_context' end
}, {
  'windwp/nvim-ts-autotag',
  event = 'VimEnter',
  dependencies = 'nvim-treesitter/nvim-treesitter'
}, {
  'karb94/neoscroll.nvim',
  event = 'VimEnter',
  config = function() require 'neoscroll'.setup() end
}, {
  'simrat39/rust-tools.nvim',
  ft = 'rust',
  config = function() require 'configs.rust_tools' end
}, {
  'windwp/nvim-spectre',
  cmd = 'Spectre',
  config = function() require 'configs.spectre' end
}, {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = function() require 'configs.telescope' end,
  dependencies = {
    'nvim-telescope/telescope-fzy-native.nvim', 'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-raw.nvim'
  }
}, {
  'hrsh7th/nvim-cmp',
  event = 'VimEnter',
  config = function() require 'cmp'.setup() end,
  dependencies = { 'hrsh7th/vim-vsnip-integ', 'hrsh7th/vim-vsnip' }
}, {
  'hrsh7th/cmp-nvim-lsp',
  event = 'VimEnter',
  dependencies = { 'hrsh7th/nvim-cmp' }
},

  {
    'hrsh7th/cmp-buffer',
    event = 'VimEnter',
    dependencies = { 'hrsh7th/nvim-cmp' }
  },
  {
    'hrsh7th/cmp-vsnip',
    event = 'VimEnter',
    dependencies = { 'hrsh7th/nvim-cmp' }
  }, { 'kdheepak/lazygit.nvim', cmd = 'LazyGit' },

  'williamboman/nvim-lsp-installer', {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function() vim.cmd([[colorscheme tokyonight-moon]]) end
}, 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap',
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  'kyazdani42/nvim-web-devicons', {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true }
}, 'goolord/alpha-nvim', 'b3nj5m1n/kommentary', 'f-person/git-blame.nvim',
  'RRethy/vim-illuminate', 'tpope/vim-fugitive',
  { 'kyazdani42/nvim-tree.lua', dependencies = 'kyazdani42/nvim-web-devicons' },
  { 'ThePrimeagen/harpoon',     dependencies = 'nvim-lua/plenary.nvim' }
})

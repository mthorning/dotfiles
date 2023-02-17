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
  { import = 'plugins' },

  'williamboman/nvim-lsp-installer',
  'nvim-lua/plenary.nvim',
  'mfussenegger/nvim-dap',
  'kyazdani42/nvim-web-devicons',
  'goolord/alpha-nvim',
  'b3nj5m1n/kommentary',
  'f-person/git-blame.nvim',
  'RRethy/vim-illuminate',
  'tpope/vim-fugitive',

  {
    "folke/zen-mode.nvim",
    config = function()
      require 'zen-mode'.setup({
        plugins = {
          tmux = { enabled = true },
          kitty = { enabled = true, font = "+4" }
        }
      })
    end
  },

  {
    'neovim/nvim-lspconfig',
    event = 'VimEnter',
    config = function() require 'configs.lsp_config' end
  },
  {
    'tami5/lspsaga.nvim',
    event = 'VimEnter',
    config = function() require 'configs.lsp_saga' end
  },
  {
    'karb94/neoscroll.nvim',
    event = 'VimEnter',
    config = function() require 'neoscroll'.setup() end
  },
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    config = function() require 'configs.rust_tools' end
  },
  {
    'windwp/nvim-spectre',
    cmd = 'Spectre',
    config = function() require 'configs.spectre' end
  },
  {
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
  },
  { 'kdheepak/lazygit.nvim', cmd = 'LazyGit' },
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
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true }
  },
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function() require 'configs.nvim_tree' end
  },
  { 'ThePrimeagen/harpoon',    dependencies = 'nvim-lua/plenary.nvim' }
})

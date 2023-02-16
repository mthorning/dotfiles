local fn = vim.fn
local execute = vim.api.nvim_command
local packer = require 'packer'

local ensure_packer = function()
  local install_path = fn.stdpath('data') ..
      '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
    install_path)
    execute 'packadd packer.nvim'
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- recompile on change
vim.cmd([[
    augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

packer.init {
  profile = { enable = true, threshold = 0 },
  display = { open_fn = require('packer.util').float }
}

local use = packer.use

use 'wbthomason/packer.nvim'

use {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function() require 'configs.which_key' end
}

use {
  'neovim/nvim-lspconfig',
  event = 'VimEnter',
  config = function() require 'configs.lsp_config' end
}

use {
  'tami5/lspsaga.nvim',
  event = 'VimEnter',
  config = function() require 'configs.lsp_saga' end
}

use {
  'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  config = function() require 'configs.treesitter' end,
  run = ':TSUpdate'
}

use {
  'nvim-treesitter/nvim-treesitter-context',
  requires = 'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  config = function() require 'configs.treesitter_context' end
}

use {
  'windwp/nvim-ts-autotag',
  event = 'VimEnter',
  requires = 'nvim-treesitter/nvim-treesitter'
}

use {
  'karb94/neoscroll.nvim',
  event = 'VimEnter',
  config = function() require 'neoscroll'.setup() end
}

use {
  'simrat39/rust-tools.nvim',
  ft = 'rust',
  config = function() require 'configs.rust_tools' end
}
use 'williamboman/nvim-lsp-installer'
use 'hrsh7th/nvim-cmp'
use { 'hrsh7th/cmp-nvim-lsp', requires = { 'hrsh7th/nvim-cmp' } }
use { 'hrsh7th/cmp-buffer', requires = { 'hrsh7th/nvim-cmp' } }
use { 'hrsh7th/cmp-vsnip', requires = { 'hrsh7th/nvim-cmp' } }
use 'hrsh7th/vim-vsnip-integ'
use 'hrsh7th/vim-vsnip'
use 'folke/tokyonight.nvim'
use 'kdheepak/lazygit.nvim'
use 'nvim-lua/plenary.nvim'
use 'mfussenegger/nvim-dap'
use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
use 'kyazdani42/nvim-web-devicons'
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
use 'goolord/alpha-nvim'
use 'windwp/nvim-spectre'
use 'b3nj5m1n/kommentary'
use 'f-person/git-blame.nvim'
use 'RRethy/vim-illuminate'
use 'tpope/vim-fugitive'
use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
use { 'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim' }
use {
  'nvim-telescope/telescope.nvim',
  requires = {
    'nvim-telescope/telescope-fzy-native.nvim', 'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-raw.nvim'
  }
}

if packer_bootstrap then packer.sync() end

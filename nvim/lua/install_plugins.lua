local fn = vim.fn
local execute = vim.api.nvim_command
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
    execute 'packadd packer.nvim'
end

-- recompile on change
vim.cmd([[
    augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

require('packer').startup({
    function(use)

        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use 'neovim/nvim-lspconfig'
        use 'simrat39/rust-tools.nvim'
        use 'tami5/lspsaga.nvim'
        use 'williamboman/nvim-lsp-installer'
        use 'hrsh7th/nvim-cmp'
        use {'hrsh7th/cmp-nvim-lsp', requires = {'hrsh7th/nvim-cmp'}}
        use {'hrsh7th/cmp-buffer', requires = {'hrsh7th/nvim-cmp'}}
        use {'hrsh7th/cmp-vsnip', requires = {'hrsh7th/nvim-cmp'}}
        use 'hrsh7th/vim-vsnip-integ'
        use 'hrsh7th/vim-vsnip'
        use 'nvim-treesitter/nvim-treesitter'
        use 'nvim-treesitter/nvim-treesitter-context'
        use 'windwp/nvim-ts-autotag'
        use 'folke/which-key.nvim'
        use 'folke/tokyonight.nvim'
        use 'kdheepak/lazygit.nvim'
        use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
        use 'kyazdani42/nvim-web-devicons'
        use {
            'nvim-lualine/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
        use 'goolord/alpha-nvim'
        use 'windwp/nvim-spectre'
        use 'b3nj5m1n/kommentary'
        use 'f-person/git-blame.nvim'
        use 'RRethy/vim-illuminate'
        use 'tpope/vim-fugitive'
        use {
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons'
        }
        use {'nikvdp/neomux', requires = 'kyazdani42/nvim-web-devicons'}
        use {'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim'}
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-telescope/telescope-fzy-native.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-live-grep-raw.nvim'
            }
        }

    end,
    config = {
        compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
        display = {open_fn = require('packer.util').float}
    }
})

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup({
    function(use)
        -- Packer can manage itself as an optional plugin
        use "wbthomason/packer.nvim"

        -- For caching
	use {'lewis6991/impatient.nvim', config = function() require('impatient') end}

        use {"nvim-treesitter/nvim-treesitter", branch = "0.5-compat", run = ":TSUpdate"}
        use "neovim/nvim-lspconfig"
        use "glepnir/lspsaga.nvim"
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/vim-vsnip"
        use {"tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp"}
        use "nikvdp/neomux"
        use "karb94/neoscroll.nvim"
        use "kabouzeid/nvim-lspinstall"
        use "nvim-lua/popup.nvim"
        use "nvim-lua/plenary.nvim"
        use "nvim-telescope/telescope.nvim"
        use "nvim-telescope/telescope-fzy-native.nvim"
        use "rafamadriz/friendly-snippets"
	use "kyazdani42/nvim-tree.lua"
        use "lewis6991/gitsigns.nvim"
        use "folke/which-key.nvim"
        use "ChristianChiarulli/dashboard-nvim"
        use "terrortylor/nvim-comment"
        use "kevinhwang91/nvim-bqf"
        use "christianchiarulli/nvcode-color-schemes.vim"
        use "kyazdani42/nvim-web-devicons"
        use "glepnir/galaxyline.nvim"
        use "unblevable/quick-scope"
        use "kdheepak/lazygit.nvim"
        use "f-person/git-blame.nvim"
        use "brooth/far.vim"
	use "windwp/nvim-autopairs"
	use "b4winckler/vim-angry"
	use "tpope/vim-repeat"
	use {"tpope/vim-surround", requires = "tpope/vim-repeat"}
	use "embear/vim-localvimrc"
	use {"phaazon/hop.nvim",
  		as = 'hop',
  		config = function()
    			require'hop'.setup()
  		end
	}
    end,
    config = {
        compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua',
	display = {
	    open_fn = require('packer.util').float,
	}
    }
})

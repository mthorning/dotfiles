local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'nvim-tree/nvim-web-devicons' },
  { import = 'plugins' },
  { 'christoomey/vim-tmux-navigator' },
  { 'NvChad/nvim-colorizer.lua',           event = 'BufReadPre' },
  { 'b3nj5m1n/kommentary',                 event = 'BufReadPre' },
  { 'RRethy/vim-illuminate',               event = 'BufReadPre' },

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
    config = function()
      require 'zen-mode'.setup()
    end
  },

  {
    'karb94/neoscroll.nvim',
    event = 'BufReadPre',
    config = function() require 'neoscroll'.setup() end
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function() require 'gitsigns'.setup() end,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'ThePrimeagen/harpoon', dependencies = 'nvim-lua/plenary.nvim' },
})

return {
  { 'nvim-tree/nvim-web-devicons',    event = 'VeryLazy' },
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy' },
  { 'NvChad/nvim-colorizer.lua',      event = 'VeryLazy' },
  { 'b3nj5m1n/kommentary',            event = 'VeryLazy' },
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    config = function()
      require('illuminate').configure({
        providers = { 'lsp' },
        delay = 200,
        filetypes_denylist = { 'NvimTree' },
      })
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#383838' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#383838' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#383838' })
    end
  },
  { 'mhinz/vim-startify' },
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

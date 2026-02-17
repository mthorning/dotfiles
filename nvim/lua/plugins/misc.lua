return {
  { 'nvim-tree/nvim-web-devicons',    event = 'VeryLazy' },
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy' },
  { 'NvChad/nvim-colorizer.lua',      event = 'VeryLazy' },
  { 'b3nj5m1n/kommentary',            event = 'VeryLazy' },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    config = function()
      require('illuminate').configure({
        providers = { 'lsp' },
        delay = 200,
        filetypes_denylist = { 'NvimTree' },
      })
      local function set_illuminate_hl()
        local visual = vim.api.nvim_get_hl(0, { name = 'Visual' })
        local bg = visual.bg
        if bg then
          vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = string.format('#%06x', bg) })
          vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = string.format('#%06x', bg) })
          vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = string.format('#%06x', bg) })
        end
      end
      vim.defer_fn(set_illuminate_hl, 100)
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.defer_fn(set_illuminate_hl, 50)
        end,
      })
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

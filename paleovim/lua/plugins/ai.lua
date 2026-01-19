return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set('i', '<Up>', 'copilot#Previous()', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Down>', 'copilot#Next()', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Right>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.keymap.set('i', '<Left>', 'copilot#Dismiss()', {
        expr = true,
        replace_keycodes = false
      })


      vim.g.copilot_no_tab_map = true
    end
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
            auto_scroll = false
          },
          inline = {
            adapter = "anthropic",
          },
        },
        display = {
          action_palette = {
            provider = 'telescope',
          },
        },
      })

      vim.cmd([[cab cc CodeCompanion]])
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        'hrsh7th/nvim-cmp',
        config = function()
          local cmp = require('cmp')
          cmp.setup {
            mapping = {
              ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
              ['<C-n>'] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Insert
              }),
              ['<C-p>'] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert
              })
            }
          }
        end
      },
      { 'echasnovski/mini.diff', version = false },
    },
  },
}

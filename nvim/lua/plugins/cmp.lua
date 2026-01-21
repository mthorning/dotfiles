return {
  {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {},
    config = function()
      local cmp = require 'cmp'

      cmp.setup {
        mapping = {
          ['<Up>'] = cmp.mapping.scroll_docs(-4),
          ['<Down>'] = cmp.mapping.scroll_docs(4),
          ['<C-c>'] = cmp.mapping.close(),
          ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
          ['<C-n>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
          }),
          ['<C-p>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
          })
        },
        sources = {
          {
            name = 'nvim_lsp',
            entry_filter = function(entry, ctx)
              local kind = require('cmp.types.lsp').CompletionItemKind[entry:get_kind()]
              return vim.tbl_contains({ 'Method', 'Function', 'Field', 'Property', 'Variable' }, kind)
            end
          }, { name = 'path' }, {
          name = 'buffer',
          options = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        }
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = 'ﲳ',
              nvim_lua = '',
              treesitter = '',
              path = 'ﱮ',
              buffer = '﬘',
              zsh = '',
              spell = '暈'
            })[entry.source.name]

            return vim_item
          end
        }
      }
    end
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'BufReadPre',
    dependencies = { 'hrsh7th/nvim-cmp' }
  },
  {
    'hrsh7th/cmp-buffer',
    event = 'BufReadPre',
    dependencies = { 'hrsh7th/nvim-cmp' }
  },
}

return {}
--[[ return {
  {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      'dcampos/cmp-snippy',
      {
        'dcampos/nvim-snippy',
        config = function()
          require 'snippy'.setup {
            mappings = {
              is = {
                ['<Tab>'] = 'expand_or_advance',
                ['<S-Tab>'] = 'previous',
              },
            }
          }
        end
      },
    },
    config = function()
      local cmp = require 'cmp'

      -- Determine if the current buffer is a TypeScript or JavaScript file
      local is_ts_or_js = function()
        local ft = vim.bo.filetype
        return ft == 'typescript' or ft == 'typescriptreact' or ft == 'javascript' or ft == 'javascriptreact'
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
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
        -- Only use LSP completion for non-TS/JS files
        enabled = function()
          return not is_ts_or_js()
        end,
        sources = {
          { name = 'nvim_lsp' }, { name = 'buffer' }, { name = 'path' }, { name = 'snippy' }, {
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
              snippy = '',
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
    enabled = false,
    event = 'BufReadPre',
    dependencies = { 'hrsh7th/nvim-cmp' }
  },
  {
    'hrsh7th/cmp-buffer',
    enabled = false,
    event = 'BufReadPre',
    dependencies = { 'hrsh7th/nvim-cmp' }
  },
} ]]

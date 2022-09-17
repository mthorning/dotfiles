local cmp = require 'cmp'

cmp.setup {
    snippet = {expand = function(args) vim.fn['vsnip#anonymous'](args.body) end},
    mapping = {
        ['<Up>'] = cmp.mapping.scroll_docs(-4),
        ['<Down>'] = cmp.mapping.scroll_docs(4),
        ['<C-c>'] = cmp.mapping.close(),
        ['<C-Space>'] = cmp.mapping.confirm({select = true}),
        ['<C-n>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
        }),
        ['<C-p>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
        })
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'path'},
        {
            name = 'buffer',
            options = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
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
                vsnip = '',
                spell = '暈'
            })[entry.source.name]

            return vim_item
        end
    }
}

require'nvim-autopairs'.setup {}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done {
    map_cr = true,
    map_complete = true,
    auto_select = true,
    insert = false,
    map_char = {all = '(', tex = '{'}
})

vim.cmd([[
  imap <expr> <C-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>'
  smap <expr> <C-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>'

  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])

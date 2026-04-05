return {
  {
    'SmiteshP/nvim-navic',
    event = 'LspAttach',
    opts = {
      highlight = true,
      separator = '  ',
      depth_limit = 6,
      lazy_update_context = false,
      safe_output = true,
      icons = {
        File          = '󰈙 ',
        Module        = '󰏗 ',
        Namespace     = '󰌗 ',
        Package       = '󰏗 ',
        Class         = '󰌗 ',
        Method        = '󰆧 ',
        Property      = '󰆨 ',
        Field         = '󰄶 ',
        Constructor   = ' ',
        Enum          = '󰒻 ',
        Interface     = '󰕘 ',
        Function      = '󰊕 ',
        Variable      = '󰀫 ',
        Constant      = '󰏿 ',
        String        = '󰀬 ',
        Number        = '󰎠 ',
        Boolean       = '◩ ',
        Array         = '󰅪 ',
        Object        = '󰅩 ',
        Key           = '󰌋 ',
        Null          = '󰟢 ',
        EnumMember    = '󰒻 ',
        Struct        = '󰌗 ',
        Event         = '󰉁 ',
        Operator      = '󰆕 ',
        TypeParameter = '󰊄 ',
      },
    },
    config = function(_, opts)
      local navic = require('nvim-navic')
      navic.setup(opts)

      -- Make the winbar blend into the editor background and use a subtler weight.
      -- Re-applied on ColorScheme so it survives dark-notify switching ayu light/dark.
      local function apply_winbar_hl()
        local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg
        vim.api.nvim_set_hl(0, 'WinBar',   { bg = normal_bg, dim = true, bold = false })
        vim.api.nvim_set_hl(0, 'WinBarNC', { bg = normal_bg, dim = true, bold = false })
      end

      apply_winbar_hl()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('NavicWinBarHL', { clear = true }),
        callback = apply_winbar_hl,
      })

      -- Attach manually so we only hook servers that report document symbols,
      -- and only set the winbar on those buffers (avoids a blank winbar line
      -- on non-LSP buffers like the dashboard or quickfix).
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('NavicAttach', { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, ev.buf)
            vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end,
      })
    end,
  },
}

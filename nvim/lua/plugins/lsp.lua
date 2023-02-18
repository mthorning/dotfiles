-- vim:foldmethod=marker
local setConfigs = function()
  local lspconfig = require('lspconfig')
  local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"
  local root_pattern = require('lspconfig').util.root_pattern

  -- efm {{{
  local eslint = {
    lintCommand = 'eslint -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { '%f:%l:%c: %m' },
    formatCommand = 'eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    formatStdin = true
  }

  local prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true
  }

  local luaformatter = { formatCommand = 'lua-format -i', formatStdin = true }

  lspconfig.efm.setup {
    cmd = { lsp_servers .. "/efm/efm-langserver" },
    on_attach = function(client)
      client.server_capabilities.document_formatting = true
      vim.cmd [[augroup lsp_formatting]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.format({}, 1000)]]
      vim.cmd [[augroup END]]
    end,
    init_options = {
      documentFormatting = true,
      codeAction = true,
      document_formatting = true
    },
    root_dir = root_pattern({ '.git/' }),

    filetypes = {
      "lua", "javascript", "javascriptreact", "javascript.jsx", "typescript",
      "typescript.tsx", "typescriptreact", "less", "scss", "css"
    },
    settings = {
      log_level = 1,
      log_file = '~/efm.log',
      rootMarkers = { ".git/" },
      languages = {
        less = { prettier },
        css = { prettier },
        html = { prettier },
        javascript = { prettier, eslint },
        javascriptreact = { prettier, eslint },
        json = { prettier },
        -- lua = { luaformatter },
        markdown = { prettier },
        scss = { prettier },
        typescript = { prettier, eslint },
        typescriptreact = { prettier, eslint },
        yaml = { prettier },
        ["javascript.jsx"] = { prettier, eslint },
        ["typescript.tsx"] = { prettier, eslint }
      }
    }
  }
  -- }}}

  -- tsserver {{{
  lspconfig.tsserver.setup {
    init_options = {
      preferences = {
        disableSuggestions = false,
        includeCompletionsForModuleExports = false
      }
    },
    cmd = {
      lsp_servers .. "/tsserver/node_modules/.bin/typescript-language-server",
      "--stdio"
    },
    on_attach = function(client)
      client.server_capabilities.document_formatting = false
      require 'illuminate'.on_attach(client)
    end
  }
  -- }}}

  -- lua_ls {{{
  local lua_ls_root_path = lsp_servers .. '/sumneko_lua/extension/server/'
  local lua_ls_binary = lua_ls_root_path .. "bin" .. "/lua-language-server"

  local runtime_path = vim.split(package.path, ';')

  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lspconfig.lua_ls.setup {
    cmd = { lua_ls_binary, "-E", lua_ls_root_path .. "/main.lua" },
    on_attach = function(client)
      require 'illuminate'.on_attach(client)
      client.server_capabilities.document_formatting = false
    end,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = runtime_path },
        diagnostics = { globals = { 'vim' } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false }
      }
    }
  }
  -- }}}

  -- jsonls {{{
  lspconfig.jsonls.setup {
    cmd = {
      lsp_servers .. "/jsonls/node_modules/.bin/vscode-json-language-server"
    }
  }
  -- }}}

  -- yamlls {{{
  lspconfig.yamlls.setup {
    cmd = {
      lsp_servers .. "/yaml/node_modules/.bin/yaml-language-server", "--stdio"
    }
  }

  -- }}}

  -- vimls {{{
  lspconfig.vimls.setup {
    cmd = {
      lsp_servers .. "/vim/node_modules/.bin/vim-language-server", "--stdio"
    }
  }
  -- }}}

  -- html {{{
  lspconfig.html.setup {
    cmd = {
      lsp_servers ..
      "/vscode-langservers-extracted/node_modules/.bin/vscode-html-language-server",
      "--stdio"
    }
  }
  -- }}}

  -- cssls {{{
  lspconfig.cssls.setup {
    cmd = {
      lsp_servers .. "/cssls/node_modules/.bin/vscode-css-language-server",
      "--stdio"
    }
  }
  -- }}}

  -- gopls {{{
  lspconfig.gopls.setup {
    cmd = { lsp_servers .. "/go/gopls" },
    root_dir = root_pattern("go.mod", ".git")
  }
  -- }}}

  -- svelte {{{
  lspconfig.svelte.setup {
    cmd = { lsp_servers .. "/svelte/node_modules/.bin/svelteserver", "--stdio" }
  }
  -- }}}

  -- pyright {{{
  lspconfig.pyright.setup {
    cmd = {
      lsp_servers .. "/python/node_modules/.bin/pyright-langserver", "--stdio"
    }
  }
  -- }}}
  -- Remember to update LspInstallAll function with new servers.
end

return {
  { 'williamboman/nvim-lsp-installer', event = 'VimEnter' },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
            { virtual_text = false })

      setConfigs()
    end
  },
  {
    'tami5/lspsaga.nvim',
    event = 'BufReadPre',
    opts = {
      debug = false,
      use_saga_diagnostic_sign = true,
      -- diagnostic sign
      error_sign = 'X',
      warn_sign = '⚠',
      hint_sign = '?',
      infor_sign = 'ℹ',
      diagnostic_header_icon = ' ',
      -- code action title icon
      code_action_icon = ' ',
      code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false
      },
      finder_definition_icon = ' ',
      finder_reference_icon = ' ',
      max_preview_lines = 10,
      finder_action_keys = {
        open = 'o',
        vsplit = 'v',
        split = 's',
        quit = 'q',
        scroll_down = '<C-f>',
        scroll_up = '<C-b>'
      },
      code_action_keys = { quit = 'q', exec = '<CR>' },
      rename_action_keys = { quit = '<C-c>', exec = '<CR>' },
      definition_preview_icon = '  ',
      border_style = 'single',
      rename_prompt_prefix = '➤',
      server_filetype_map = {}
    }
  }
}

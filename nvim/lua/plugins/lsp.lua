-- vim:foldmethod=marker
local setConfigs = function()
  local lspconfig = require('lspconfig')
  local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"
  local root_pattern = require('lspconfig').util.root_pattern

  -- astro {{{
  lspconfig.astro.setup { 
    cmd = {
      lsp_servers .. "/astro/node_modules/.bin/astro-ls",
      "--stdio"
    },
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
      -- client.server_capabilities.document_formatting = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
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
      client.server_capabilities.document_formatting = false
      require 'illuminate'.on_attach(client)
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
      lsp_servers .. "/jsonls/node_modules/.bin/vscode-json-language-server", "--stdio"
    },
    init_options = {
      provideFormatter = true
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
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local status, null_ls = pcall(require, "null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      if (not status) then return end

      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.eslint_d.with({
            diagnostics_format = '[eslint] #{m}\n(#{c})'
          }),
          null_ls.builtins.formatting.eslint_d.with({
            filetypes = {
              "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "scss", "html", "yaml",
              "markdown", "graphql", "md", "txt",
            },
          }),
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.lsp.buf.format({
              bufnr = bufnr,
              filter = function(f_client)
                return f_client.name == "null-ls"
              end
            })

            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end
  },
}

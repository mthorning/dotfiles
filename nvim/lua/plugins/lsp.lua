-- vim:foldmethod=marker
local setConfigs = function()
  local lspconfig = require('lspconfig')
  local lsp_servers = vim.fn.stdpath('data') .. "/mason/bin"
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
  lspconfig["ts_ls"].setup {
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
  local lua_ls_binary = lsp_servers .. "/lua-language-server"

  local runtime_path = vim.split(package.path, ';')

  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lspconfig.lua_ls.setup {
    cmd = { lua_ls_binary, "-E", lua_ls_binary .. "/main.lua" },
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
      "/html/node_modules/.bin/vscode-html-language-server",
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

  -- eslint {{{
  lspconfig.eslint.setup {
    cmd = { lsp_servers .. "/vscode-eslint/node_modules/.bin/vscode-eslint-language-server", "--stdio" },
    root_dir = root_pattern(
      "eslint.config.js",
      ".eslintrc.js",
      ".eslintrc.yaml",
      "node_modules",
      ".git"
    ),
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
    settings = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine"
        },
        showDocumentation = {
          enable = true
        }
      },
      codeActionOnSave = {
        enable = false,
        mode = "all"
      },
      experimental = {
        useFlatConfig = false
      },
      format = true,
      nodePath = "",
      onIgnoredFiles = "off",
      problems = {
        shortenToSingleLine = false
      },
      quiet = false,
      rulesCustomizations = {},
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = {
        mode = "location"
      }
    }
  }
  -- }}}

  -- zig {{{
  vim.g.zig_fmt_parse_errors = 0
  vim.g.zig_fmt_autosave = 0
  vim.cmd [[autocmd BufWritePre *.zig lua vim.lsp.buf.format()]]
  lspconfig.zls.setup {
    cmd = { lsp_servers .. "/zls" },
  }
  -- }}}
end

return {
  { "williamboman/mason.nvim", opts = {}, event = 'VimEnter' },
  { "williamboman/mason-lspconfig.nvim", event = 'VimEnter'  },
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
    'nvimdev/lspsaga.nvim',
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
}

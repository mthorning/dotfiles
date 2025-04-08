-- vim:foldmethod=marker
local makeNicerPopups = function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = {
      border = "single",
      format = function(diagnostic)
        return string.format(
          "%s (%s) [%s]",
          diagnostic.message,
          diagnostic.source,
          diagnostic.code or diagnostic.user_data.lsp.code
        )
      end,
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "single",
      title = "hover"
    }
  )
end

local getConfigs = function()
  local lspconfig = require('lspconfig')
  local lsp_servers = vim.fn.stdpath('data') .. "/mason/bin"

  return {
    -- ts_ls {{{
    ts_ls = {
      root_dir = function(...)
        return require 'lspconfig.util'.root_pattern(".git")(...)
      end,
      init_options = {
        preferences = {
          disableSuggestions = false,
          includeCompletionsForModuleExports = true,
          sortImports = true
        }
      },
      cmd = {
        lsp_servers .. "/typescript-language-server",
        "--stdio"
      },
      filetypes = {}, -- Disable typescript-language-server for all filetypes
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          group = vim.api.nvim_create_augroup("PrettierGroup", { clear = true }),
          command = "Prettier",
        })
      end
    },
    -- }}}

    -- lua_ls {{{
    lua_ls = {
      on_init = function(client)
        local runtime_path = vim.split(package.path, ';')

        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
              'Snacks',
              'vim',
            },
          },
        }
      }
    },
    -- }}}

    -- jsonls {{{
    jsonls = {
      cmd = {
        lsp_servers .. "/vscode-json-language-server", "--stdio"
      },
      init_options = {
        provideFormatter = true
      }
    },
    -- }}}

    -- yamlls {{{
    yamlls = {
      cmd = {
        lsp_servers .. "/yaml-language-server", "--stdio"
      }
    },

    -- }}}

    -- vimls {{{
    vimls = {
      cmd = {
        lsp_servers .. "/vim-language-server", "--stdio"
      }
    },
    -- }}}

    -- html {{{
    html = {
      cmd = {
        lsp_servers ..
        "/vscode-html-language-server",
        "--stdio"
      }
    },
    -- }}}

    -- cssls {{{
    cssls = {
      cmd = {
        lsp_servers .. "/vscode-css-language-server",
        "--stdio"
      }
    },
    -- }}}

    -- gopls {{{
    gopls = {
      cmd = { lsp_servers .. "/gopls" },
      root_dir = lspconfig.util.root_pattern("go.mod", ".git")
    },
    -- }}}

    -- svelte {{{
    svelte = {
      cmd = { lsp_servers .. "/svelteserver", "--stdio" }
    },
    -- }}}

    -- pyright {{{
    pyright = {
      cmd = {
        lsp_servers .. "/pyright-langserver", "--stdio"
      }
    },
    -- }}}

    -- eslint {{{
    --[[ eslint = {
      root_dir = function(...)
        return require'lspconfig.util'.root_pattern(".git")(...)
      end,
      cmd = { lsp_servers .. "/vscode-eslint-language-server", "--stdio" },
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("EslintGroup", { clear = true }),
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
    }, ]]
    -- }}}

    -- zig {{{
    zls = {
      cmd = { lsp_servers .. "/zls" },
      on_attach = function()
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0
        vim.cmd [[autocmd BufWritePre *.zig lua vim.lsp.buf.format()]]
      end
    },
    -- }}}
  }
end

return {
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Disable diagnostics display from native LSP to avoid conflicts with COC
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
            { virtual_text = false, signs = false, underline = false, update_in_insert = false })

      local servers = getConfigs()

      for server, config in pairs(servers) do
        -- Disable attaching document formatting capability for LSP servers
        local orig_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
          -- Disable document formatting from LSP so it doesn't conflict with COC
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          
          -- Call the original on_attach if it exists
          if orig_on_attach then
            orig_on_attach(client, bufnr)
          end
        end
        
        require 'lspconfig'[server].setup(config)
      end

      makeNicerPopups()
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}

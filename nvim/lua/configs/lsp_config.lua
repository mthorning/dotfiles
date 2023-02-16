-- vim:foldmethod=marker
-- init {{{
local lspconfig = require('lspconfig')
local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"
local root_pattern = lspconfig.util.root_pattern

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
      { virtual_text = false })
-- }}}

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
      lua = { luaformatter },
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
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false }
    }
  }
}
-- }}}

-- jsonls {{{
require 'lspconfig'.jsonls.setup {
  cmd = {
    lsp_servers .. "/jsonls/node_modules/.bin/vscode-json-language-server"
  }
}
-- }}}

-- yamlls {{{
require 'lspconfig'.yamlls.setup {
  cmd = {
    lsp_servers .. "/yaml/node_modules/.bin/yaml-language-server", "--stdio"
  }
}

-- }}}

-- vimls {{{
require 'lspconfig'.vimls.setup {
  cmd = {
    lsp_servers .. "/vim/node_modules/.bin/vim-language-server", "--stdio"
  }
}
-- }}}

-- html {{{
require 'lspconfig'.html.setup {
  cmd = {
    lsp_servers ..
    "/vscode-langservers-extracted/node_modules/.bin/vscode-html-language-server",
    "--stdio"
  }
}
-- }}}

-- cssls {{{
require 'lspconfig'.cssls.setup {
  cmd = {
    lsp_servers .. "/cssls/node_modules/.bin/vscode-css-language-server",
    "--stdio"
  }
}
-- }}}

-- gopls {{{
require 'lspconfig'.gopls.setup {
  cmd = { lsp_servers .. "/go/gopls" },
  root_dir = root_pattern("go.mod", ".git")
}
-- }}}

-- svelte {{{
require 'lspconfig'.svelte.setup {
  cmd = { lsp_servers .. "/svelte/node_modules/.bin/svelteserver", "--stdio" }
}
-- }}}

-- pyright {{{
require 'lspconfig'.pyright.setup {
  cmd = {
    lsp_servers .. "/python/node_modules/.bin/pyright-langserver", "--stdio"
  }
}
-- }}}
-- Remember to update LspInstallAll function with new servers.

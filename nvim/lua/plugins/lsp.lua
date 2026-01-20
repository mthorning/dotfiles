local lsp_servers = vim.fn.stdpath('data') .. "/mason/bin"

vim.lsp.config['lua_ls'] = {
  cmd = { lsp_servers .. "/lua-language-server" },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    diagnostics = {
      globals = {
        "vim",
      },
    },
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      }
    }
  }
}
vim.lsp.enable('lua_ls')

vim.lsp.config['ts_ls'] = {
  root_markers = { '.git' },
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
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      group = vim.api.nvim_create_augroup("PrettierGroup", { clear = true }),
      command = "Prettier",
    })
  end
}
vim.lsp.enable('ts_ls')

vim.lsp.config['gopls'] = {
  cmd = { lsp_servers .. "/gopls" },
  root_markers = { 'go.mod', '.git' }
}
vim.lsp.enable('gopls')

vim.lsp.config['rust-analyzer'] = {
  cmd = { lsp_servers .. "/rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { 'Cargo.toml', '.git' },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    }
  }
}
vim.lsp.enable('rust-analyzer')


return {
  { "williamboman/mason.nvim", opts = {} },

}

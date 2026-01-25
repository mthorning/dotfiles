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
  filetypes = { "go" },
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
      checkOnSave = true,
      check = {
        command = "clippy"
      },
    }
  }
}
vim.lsp.enable('rust-analyzer')

local buffers_with_conflicts = {}

local function has_conflict_markers(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match("^<<<<<<<") or line:match("^%%%%%%%") or
        line:match("^%+%+%+%+%+%+%+") or line:match("^>>>>>>>") then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if has_conflict_markers(bufnr) then
      vim.diagnostic.enable(false, { bufnr = bufnr })
      buffers_with_conflicts[bufnr] = true
    end
  end,
})

local function check_and_update_diagnostics(bufnr)
  local has_conflicts = has_conflict_markers(bufnr)
  local was_disabled = buffers_with_conflicts[bufnr]

  if has_conflicts and not was_disabled then
    vim.diagnostic.enable(false, { bufnr = bufnr })
    buffers_with_conflicts[bufnr] = true
  elseif not has_conflicts and was_disabled then
    vim.diagnostic.enable(true, { bufnr = bufnr })
    buffers_with_conflicts[bufnr] = nil
  end
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    check_and_update_diagnostics(bufnr)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    check_and_update_diagnostics(bufnr)
  end,
})


return {
  { "williamboman/mason.nvim", opts = {} },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        go = vim.fn.executable("golangci-lint") == 1 and { "golangcilint" } or {},
      }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

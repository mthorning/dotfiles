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
  on_attach = function(client, bufnr)
    -- Work around occasional rust-analyzer panics triggered by on-type formatting (e.g. on Enter).
    client.server_capabilities.documentOnTypeFormattingProvider = nil
  end,
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

local eslint_config_files = {
  '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml',
  '.eslintrc.yml', '.eslintrc.json', 'eslint.config.js', 'eslint.config.mjs',
  'eslint.config.cjs', 'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
}

vim.lsp.config['eslint'] = {
  cmd = { lsp_servers .. "/vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) then return end
    local root = vim.fs.root(bufnr, { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lock', '.git' })
      or vim.fn.getcwd()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find(eslint_config_files, {
      path = filename, type = 'file', limit = 1, upward = true,
      stop = vim.fs.dirname(root),
    })[1]
    if found then on_dir(root) end
  end,
  before_init = function(_, config)
    local root = config.root_dir
    if not root then return end
    config.settings = config.settings or {}
    config.settings.workspaceFolder = {
      uri = root,
      name = vim.fn.fnamemodify(root, ':t'),
    }
    local flat_configs = vim.tbl_filter(function(f) return f:match('config') end, eslint_config_files)
    for _, f in ipairs(flat_configs) do
      local found = vim.fn.globpath(root, f, true, true)
      found = vim.tbl_filter(function(p) return not p:find('[/\\]node_modules[/\\]') end, found)
      if #found > 0 then
        config.settings.experimental = { useFlatConfig = true }
        break
      end
    end
  end,
  settings = {
    validate = 'on',
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeActionOnSave = { enable = false, mode = 'all' },
    format = true,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'auto' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
  },
  handlers = {
    ['eslint/openDoc'] = function(_, result)
      if result then vim.ui.open(result.url) end
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function(_, result)
      if not result then return end
      return 4
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('[eslint] probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('[eslint] Unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  },
}
vim.lsp.enable('eslint')

vim.lsp.config['pyright'] = {
  cmd = { lsp_servers .. "/pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' }
}
vim.lsp.enable('pyright')

local buffers_with_conflicts = {}

local function has_conflict_markers(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match("^<<<<<<<") or line:match("^%%%%%%%%%%%%%%") or
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
        -- javascript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
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

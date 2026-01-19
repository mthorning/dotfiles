return {
  'simrat39/rust-tools.nvim',
  event = 'VeryLazy',
  ft = 'rust',
  enabled = false,
  config = function()
    local rt = require("rust-tools")
    local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"

    rt.setup {
      server = {
        cmd = { lsp_servers .. "/rust/rust-analyzer" },
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<Leader>lh", rt.hover_actions.hover_actions,
            { buffer = bufnr })
          -- Code action groups
          vim.keymap.set("n", "<Leader>la",
            rt.code_action_group.code_action_group,
            { buffer = bufnr })
        end
      },
      hover_actions = { auto_focus = true },
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb"
        }
      }
    }
  end
}

return {
  'folke/which-key.nvim',
  lazy = false,
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
  },
  opts = {
    preset = 'modern',
  },
  config = function()
    local wk = require('which-key')

    local add_toqflist = function()
      local diagnostics = vim.diagnostic.get(0, {
        everity_sort = true
      })
      vim.fn.setqflist({}, 'r', {
        title =
        "Diagnostics",
        items =
            vim.diagnostic.toqflist(diagnostics)
      })
      vim.cmd("copen")
    end

    local add_conflicts_to_qflist = function()
      vim.cmd('silent! vimgrep /<<<<<<< /gj **/*')
      vim.cmd('copen')
    end


    wk.add({
      { '<C-n>',      '<CMD>lua vim.diagnostic.goto_next()<CR>',                                                 desc = 'Next Diagnostic',        nowait = false,    remap = false },
      { '<C-p>',      '<CMD>lua vim.diagnostic.goto_prev()<CR>',                                                 desc = 'Prev Diagnostic',        nowait = false,    remap = false },

      { '<leader>a',  '<CMD>wa<CR>',                                                                             desc = 'Save All',               nowait = false,    remap = false },

      { '<leader>c',  group = 'QuickFix',                                                                        nowait = false,                  remap = false },
      { '<leader>cc', '<CMD>cclose<CR>',                                                                         desc = 'Close',                  nowait = false,    remap = false },
      { '<leader>cd', add_toqflist,                                                                              desc = 'Diagnostics',            nowait = false,    remap = false },
      { '<leader>cf', add_conflicts_to_qflist,                                                                   desc = 'Find conflicts',         nowait = false,    remap = false },
      { '<leader>cn', '<CMD>cnext<CR>',                                                                          desc = 'Next',                   nowait = false,    remap = false },
      { '<leader>co', '<CMD>copen<CR>',                                                                          desc = 'Open',                   nowait = false,    remap = false },
      { '<leader>cp', '<CMD>cprev<CR>',                                                                          desc = 'Previous',               nowait = false,    remap = false },

      { '<leader>d',  group = 'Debug',                                                                           nowait = false,                  remap = false },
      { '<leader>dB', '<CMD>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',        desc = 'Conditional breakpoint', nowait = false,    remap = false },
      { '<leader>dC', '<CMD>lua require"dap".clear_breakpoints()<CR>',                                           desc = 'Clear breakpoints',      nowait = false,    remap = false },
      { '<leader>dO', '<CMD>lua require"dap".step_out()<CR>',                                                    desc = 'Step out',               nowait = false,    remap = false },
      { '<leader>db', '<CMD>lua require"dap".toggle_breakpoint()<CR>',                                           desc = 'Toggle breakpoint',      nowait = false,    remap = false },
      { '<leader>dc', '<CMD>lua require"dap".continue()<CR>',                                                    desc = 'Start/continue',         nowait = false,    remap = false },
      { '<leader>di', '<CMD>lua require"dap".step_into()<CR>',                                                   desc = 'Step into',              nowait = false,    remap = false },
      { '<leader>dl', '<CMD>lua require"dap".run_last()<CR>',                                                    desc = 'Last',                   nowait = false,    remap = false },
      { '<leader>dm', '<CMD>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', desc = 'Message',                nowait = false,    remap = false },
      { '<leader>do', '<CMD>lua require"dap".step_over()<CR>',                                                   desc = 'Step over',              nowait = false,    remap = false },
      { '<leader>dr', '<CMD>lua require"dap".repl.open()<CR>',                                                   desc = 'REPL',                   nowait = false,    remap = false },
      { '<leader>dx', '<CMD>DapClose<CR>',                                                                      desc = 'Close Session',          nowait = false,    remap = false },
      { '<leader>de', '<CMD>lua require("dapui").eval()<CR>',                                                    mode = { 'n', 'v' },             desc = 'Evaluate', nowait = false, remap = false },

      { '<leader>e',  '<CMD>Yazi<CR>',                                                                           desc = 'Explorer',               nowait = false,    remap = false },

      { '<leader>f',  group = 'Find',                                                                            nowait = false,                  remap = false },
      { '<leader>fS', '<CMD>Telescope search_history<CR>',                                                       desc = 'Search History',         nowait = false,    remap = false },
      { '<leader>fb', '<CMD>Telescope buffers<CR>',                                                              desc = 'Buffer',                 nowait = false,    remap = false },
      { '<leader>ff', '<CMD>Telescope find_files<CR>',                                                           desc = 'File',                   nowait = false,    remap = false },
      { '<leader>fg', '<CMD>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>',              desc = 'Grep',                   nowait = false,    remap = false },
      { '<leader>fl', '<CMD>Telescope resume<CR>',                                                               desc = 'Last Query',             nowait = false,    remap = false },
      { '<leader>fm', '<CMD>Telescope marks<CR>',                                                                desc = 'Marks',                  nowait = false,    remap = false },
      { '<leader>fh', '<CMD>Telescope help_tags<CR>',                                                            desc = 'Help',                   nowait = false,    remap = false },
      { '<leader>fq', '<CMD>Telescope quickfix<CR>',                                                             desc = 'QuickFix',               nowait = false,    remap = false },
      { '<leader>fr', '<CMD>Telescope oldfiles<CR>',                                                             desc = 'Recent',                 nowait = false,    remap = false },
      { '<leader>fs', '<CMD>Telescope lsp_dynamic_workspace_symbols<CR>',                                        desc = 'Symbols',                nowait = false,    remap = false },
      { '<leader>ft', "<CMD>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",            desc = 'Text',                   nowait = false,    remap = false },
      { '<leader>fw', '<CMD>Telescope grep_string<CR>',                                                          desc = 'Word under cursor',      nowait = false,    remap = false },

      { '<leader>l',  group = 'LSP',                                                                             nowait = false,                  remap = false },
      { '<leader>l?', '<CMD>Mason<CR>',                                                                          desc = 'Server Info',            nowait = false,    remap = false },
      { '<leader>l/', '<CMD>checkhealth vim.lsp<CR>',                                                            desc = 'Server Info',            nowait = false,    remap = false },
      { '<leader>la', '<CMD>lua vim.lsp.buf.code_action()<CR>',                                                  desc = 'Code Action',            nowait = false,    remap = false },
      { '<leader>lD', '<CMD>lua vim.lsp.buf.declaration()<CR>',                                                  desc = 'Declaration',            nowait = false,    remap = false },
      { '<leader>ld', '<CMD>lua vim.lsp.buf.definition()<CR>',                                                   desc = 'Definition',             nowait = false,    remap = false },
      { '<leader>lv', '<CMD>vsplit<CR><CMD>lua vim.lsp.buf.definition()<CR>',                                    desc = 'Definition (vsplit)',    nowait = false,    remap = false },
      { '<leader>le', '<CMD>lua vim.diagnostic.open_float()<CR>',                                                desc = 'Diagnostics',            nowait = false,    remap = false },
      { '<leader>lF', '<CMD>lua vim.lsp.buf.format{ async = true }<CR>',                                         desc = 'Format',                 nowait = false,    remap = false },
      { '<leader>lh', '<CMD>lua vim.lsp.buf.hover()<CR>',                                                        desc = 'Hover',                  nowait = false,    remap = false },
      { '<leader>li', '<CMD>lua vim.lsp.buf.implementation()<CR>',                                               desc = 'Implementation',         nowait = false,    remap = false },
      { '<leader>lk', '<CMD>lua vim.lsp.buf.signature_help()<CR>',                                               desc = 'Signature Help',         nowait = false,    remap = false },
      { '<leader>lR', '<CMD>LspRename<CR>',                                                                      desc = 'Rename',                 nowait = false,    remap = false },
      { '<leader>lr', '<CMD>Telescope lsp_references<CR>',                                                       desc = 'References',             nowait = false,    remap = false },
      { '<leader>lS', '<CMD>Telescope lsp_dynamic_workspace_symbols<CR>',                                        desc = 'Workspace Symbols',      nowait = false,    remap = false },
      { '<leader>ls', '<CMD>Telescope lsp_document_symbols<CR>',                                                 desc = 'Document Symbols',       nowait = false,    remap = false },
      { '<leader>lt', '<CMD>lua vim.lsp.buf.type_definition()<CR>',                                              desc = 'Type Definition',        nowait = false,    remap = false },
      {
        '<leader>lx',
        function()
          vim.cmd('LspRestart')
        end,
        desc = 'Restart',
        nowait = false,
        remap = false
      },

      { '<leader>m',  '<CMD>Telescope tmux_sessionizer<CR>', desc = 'Change repo',  nowait = false,         remap = false },

      { '<leader>p',  '<CMD>Lazy<CR>',                       desc = 'Plugins',      nowait = false,         remap = false },
      { '<leader>q',  '<CMD>q<CR>',                          desc = 'Quit',         nowait = false,         remap = false },

      { '<leader>w',  '<cmd>w<CR>',                          desc = 'Save',         nowait = false,         remap = false },

      { '<leader>y',  group = 'Yank',                        nowait = false,        remap = false },
      { '<leader>ya', '<CMD>YankAbsolutePath<CR>',           mode = { 'n', 'v' },   desc = 'Absolute path', nowait = false, remap = false },
      { '<leader>yr', '<CMD>YankRelativePath<CR>',           mode = { 'n', 'v' },   desc = 'Relative path', nowait = false, remap = false },
      { '<leader>u',  '<cmd>UndotreeToggle<CR>',             desc = 'Undo tree',    nowait = false,         remap = false },

      { '<leader>;',  '<CMD>Startify<CR>',                   desc = 'Start screen', nowait = false,         remap = false },
    })
  end,
}

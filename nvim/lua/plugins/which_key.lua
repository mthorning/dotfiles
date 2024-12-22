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
    wk.add({
      { '<leader>;',       '<CMD>lua Snacks.dashboard()<CR>',                                                         desc = 'Dashboard',                nowait = false,    remap = false },
      { '<leader><s-tab>', hidden = true,                                                                             nowait = false,                    remap = false },
      { '<leader><tab>',   hidden = true,                                                                             nowait = false,                    remap = false },
      { '<leader>a',       '<CMD>wa<CR>',                                                                             desc = 'Save All',                 nowait = false,    remap = false },

      { '<leader>A',       group = 'AutoRun' },
      { '<leader>Ar',      '<CMD>AutoRun<CR>',                                                                        desc = 'Run',                      nowait = false,    remap = false },
      { '<leader>As',      '<CMD>AutoRunStop<CR>',                                                                    desc = 'Stop',                     nowait = false,    remap = false },

      { '<leader>c',       group = 'QuickFix',                                                                        nowait = false,                    remap = false },
      { '<leader>bd',      '<CMD>lua Snacks.bufdelete.delete()<CR>',                                                  desc = 'Delete buffer',            nowait = false,    remap = false },
      { '<leader>ba',      '<CMD>lua Snacks.bufdelete.all()<CR>',                                                     desc = 'Delete all buffers',       nowait = false,    remap = false },
      { '<leader>bn',      '<CMD>lua Snacks.notify.info("Buffer "..vim.api.nvim_get_current_buf())<CR>',              desc = 'Show number',              nowait = false,    remap = false },

      { '<leader>c',       group = 'QuickFix',                                                                        nowait = false,                    remap = false },
      { '<leader>cc',      '<CMD>cclose<CR>',                                                                         desc = 'Close',                    nowait = false,    remap = false },
      { '<leader>cn',      '<CMD>cnext<CR>',                                                                          desc = 'Next',                     nowait = false,    remap = false },
      { '<leader>co',      '<CMD>copen<CR>',                                                                          desc = 'Open',                     nowait = false,    remap = false },
      { '<leader>cp',      '<CMD>cprev<CR>',                                                                          desc = 'Previous',                 nowait = false,    remap = false },

      { '<leader>d',       group = 'Debug',                                                                           nowait = false,                    remap = false },
      { '<leader>dB',      '<CMD>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',        desc = 'Conditional breakpoint',   nowait = false,    remap = false },
      { '<leader>dC',      '<CMD>lua require"dap".clear_breakpoints()<CR>',                                           desc = 'Clear breakpoints',        nowait = false,    remap = false },
      { '<leader>dO',      '<CMD>lua require"dap".step_out()<CR>',                                                    desc = 'Step out',                 nowait = false,    remap = false },
      { '<leader>db',      '<CMD>lua require"dap".toggle_breakpoint()<CR>',                                           desc = 'Toggle breakpoint',        nowait = false,    remap = false },
      { '<leader>dc',      '<CMD>lua require"dap".continue()<CR>',                                                    desc = 'Start/continue',           nowait = false,    remap = false },
      { '<leader>di',      '<CMD>lua require"dap".step_into()<CR>',                                                   desc = 'Step into',                nowait = false,    remap = false },
      { '<leader>dl',      '<CMD>lua require"dap".run_last()<CR>',                                                    desc = 'Last',                     nowait = false,    remap = false },
      { '<leader>dm',      '<CMD>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', desc = 'Message',                  nowait = false,    remap = false },
      { '<leader>do',      '<CMD>lua require"dap".step_over()<CR>',                                                   desc = 'Step over',                nowait = false,    remap = false },
      { '<leader>dr',      '<CMD>lua require"dap".repl.open()<CR>',                                                   desc = 'REPL',                     nowait = false,    remap = false },
      { '<leader>dx',      '<CMD>lua require"dap".disconnect()<CR>',                                                  desc = 'Exit',                     nowait = false,    remap = false },
      { '<leader>de',      '<CMD>lua require("dapui").eval()<CR>',                                                    mode = { 'n', 'v' },               desc = 'Evaluate', nowait = false, remap = false },

      { '<leader>e',       '<CMD>Oil --float<CR>',                                                                           desc = 'Explorer',                 nowait = false,    remap = false },

      { '<leader>f',       group = 'Find',                                                                            nowait = false,                    remap = false },
      { '<leader>fS',      '<CMD>Telescope search_history<CR>',                                                       desc = 'Search History',           nowait = false,    remap = false },
      { '<leader>fb',      '<CMD>Telescope buffers<CR>',                                                              desc = 'Buffer',                   nowait = false,    remap = false },
      { '<leader>fc',      '<CMD>Telescope command_history<CR>',                                                      desc = 'Command History',          nowait = false,    remap = false },
      { '<leader>fC',      '<CMD>:lua require("telescope.builtin").find_files{ cwd = vim.fn.stdpath("config") }<CR>', desc = 'Command History',          nowait = false,    remap = false },
      { '<leader>ff',      '<CMD>Telescope find_files<CR>',                                                           desc = 'File',                     nowait = false,    remap = false },
      { '<leader>fg',      '<CMD>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>',              desc = 'Grep',                     nowait = false,    remap = false },
      { '<leader>fl',      '<CMD>Telescope resume<CR>',                                                               desc = 'Last Query',               nowait = false,    remap = false },
      { '<leader>fm',      '<CMD>Telescope marks<CR>',                                                                desc = 'Marks',                    nowait = false,    remap = false },
      { '<leader>fh',      '<CMD>Telescope help_tags<CR>',                                                            desc = 'Help',                     nowait = false,    remap = false },
      { '<leader>fp',      '<CMD>lua require("spectre").open_visual()<CR>',                                           desc = 'Project',                  nowait = false,    remap = false },
      { '<leader>fq',      '<CMD>Telescope quickfix<CR>',                                                             desc = 'QuickFix',                 nowait = false,    remap = false },
      { '<leader>fr',      '<CMD>Telescope oldfiles<CR>',                                                             desc = 'Recent',                   nowait = false,    remap = false },
      { '<leader>fs',      '<CMD>Telescope lsp_dynamic_workspace_symbols<CR>',                                        desc = 'Symbols',                  nowait = false,    remap = false },
      { '<leader>ft',      "<CMD>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",            desc = 'Text',                     nowait = false,    remap = false },
      { '<leader>fw',      '<CMD>Telescope grep_string<CR>',                                                          desc = 'Word under cursor',        nowait = false,    remap = false },

      { '<leader>d',       group = 'Git',                                                                             nowait = false,                    remap = false },
      { '<leader>go',      '<CMD>lua Snacks.lazygit()<CR>',                                                           desc = 'LazyGit',                  nowait = false,    remap = false },
      { '<leader>gb',      '<CMD>lua Snacks.git.blame_line()<CR>',                                                    desc = 'Blame',                    nowait = false,    remap = false },
      { '<leader>gx',      '<CMD>lua Snacks.gitbrowse()<CR>',                                                         desc = 'Open repo',                nowait = false,    remap = false },

      { '<leader>h',       group = 'Harpoon',                                                                         nowait = false,                    remap = false },
      { '<leader>ha',      '<CMD>lua require("harpoon.mark").add_file()<CR>',                                         desc = 'Add Mark',                 nowait = false,    remap = false },
      { '<leader>he',      '<CMD>lua require("harpoon.ui").toggle_quick_menu()<CR>',                                  desc = 'Show Marks',               nowait = false,    remap = false },
      { '<leader>hn',      '<CMD>lua require("harpoon.ui").nav_next()<CR>',                                           desc = 'Next',                     nowait = false,    remap = false },
      { '<leader>hp',      '<CMD>lua require("harpoon.ui").nav_prev()<CR>',                                           desc = 'Prev',                     nowait = false,    remap = false },
      { '<leader>hs',      '<CMD>Telescope harpoon marks<CR>',                                                        desc = 'Search',                   nowait = false,    remap = false },
      { '<leader>j',       '<CMD>silent !tmux neww ff<CR>',                                                           desc = 'Manage feature flags',     nowait = false,    remap = false },

      { '<leader>l',       group = 'LSP',                                                                             nowait = false,                    remap = false },
      { '<leader>l/',      '<CMD>LspInfo<CR>',                                                                        desc = 'Info',                     nowait = false,    remap = false },
      { '<leader>l?',      '<CMD>Mason<CR>',                                                                          desc = 'Server Info',              nowait = false,    remap = false },
      { '<leader>lF',      '<CMD>lua vim.lsp.buf.format({ async = true })<CR>',                                       desc = 'Format',                   nowait = false,    remap = false },
      { '<leader>ld',      '<CMD>Telescope lsp_definitions<CR>',                                                      desc = 'Goto Definition',          nowait = false,    remap = false },
      { '<leader>lf',      '<CMD>Telescope lsp_references<CR>',                                                       desc = 'References',               nowait = false,    remap = false },
      { '<leader>lh',      '<CMD>lua vim.lsp.buf.hover()<CR>',                                                        desc = 'Hover',                    nowait = false,    remap = false },
      { '<leader>ll',      '<CMD>lua vim.diagnostic.open_float()<CR>',                                                desc = 'Line Diagnostic',          nowait = false,    remap = false },
      { '<leader>lr',      '<CMD>LspRename<CR>',                                                       desc = 'Rename',                   nowait = false,    remap = false },
      { '<leader>ls',      '<CMD>Telescope lsp_document_symbols<CR>',                                                 desc = 'Symbols',                  nowait = false,    remap = false },
      { '<leader>lt',      '<CMD>Telescope lsp_type_definitions<CR>',                                                 desc = 'Goto Type Definition',     nowait = false,    remap = false },
      { '<leader>lv',      '<CMD>vsplit | Telescope lsp_definitions<CR>',                                             desc = 'Goto Definition in split', nowait = false,    remap = false },
      { '<leader>lx',      '<CMD>LspRestart<CR>',                                                                     desc = 'Restart',                  nowait = false,    remap = false },

      { '<leader>m',       '<CMD>Telescope tmux_sessionizer<CR>',                                                     desc = 'Change repo',              nowait = false,    remap = false },

      { '<leader>n',       group = 'Notifications',                                                                   nowait = false,                    remap = false },
      { '<leader>nh',      '<CMD>lua Snacks.notifier.show_history()<CR>',                                             desc = 'History',                  nowait = false,    remap = false },
      { '<leader>nx',      '<CMD>lua Snacks.notifier.hide()<CR>',                                                     desc = 'Clear',                    nowait = false,    remap = false },

      { '<leader>p',       '<CMD>Lazy<CR>',                                                                           desc = 'Plugins',                  nowait = false,    remap = false },
      { '<leader>P',       '<CMD>Prettier<CR>',                                                                       desc = 'Prettier',                 nowait = false,    remap = false },
      { '<leader>q',       '<CMD>q<CR>',                                                                              desc = 'Quit',                     nowait = false,    remap = false },
      { '<leader>r',       '<CMD>GrugFar ripgrep<CR>',                                                                desc = 'Replace',                  nowait = false,    remap = false },

      { '<leader>t',       group = 'Terminal',                                                                        nowait = false,                    remap = false },
      { '<leader>t.',      '<cmd>term<CR>',                                                                           desc = 'Here',                     nowait = false,    remap = false },
      { '<leader>ts',      '<cmd>split term://zsh | :startinsert<CR>',                                                desc = 'Horizontal split',         nowait = false,    remap = false },
      { '<leader>tt',      '<cmd>tabnew | :edit term://zsh | :startinsert<CR>',                                       desc = 'Tab',                      nowait = false,    remap = false },
      { '<leader>tv',      '<cmd>vsplit term://zsh | :startinsert<CR>',                                               desc = 'Vert split',               nowait = false,    remap = false },
      { '<leader>tt',      '<CMD>Floaterminal<CR>',                                                                   desc = 'Float',                    nowait = false,    remap = false },

      { '<leader>w',       '<cmd>w<CR>',                                                                              desc = 'Save',                     nowait = false,    remap = false },

      { '<leader>x',       group = 'Execute lua',                                                                         nowait = false,                    remap = false },
      { '<leader>xf',      '<cmd>%lua<CR>',                                                                           desc = 'Execute file',             nowait = false,    remap = false },
      { '<leader>xs',      "<cmd>'<,'>lua<CR>",                                                                       desc = 'Execute selection',        nowait = false,    remap = false },
      { '<leader>xl',      "<cmd>.lua<CR>",                                                                           desc = 'Execute line',             nowait = false,    remap = false },


      { '<leader>y',       '<cmd>let @+ = expand("%:p")<CR>',                                                         desc = 'Copy path',                nowait = false,    remap = false },
      { '<leader>z',       '<cmd>lua require("snacks").zen()<CR>',                                                    desc = 'Zen Mode',                 nowait = false,    remap = false },
      { '<leader>u',       '<cmd>UndotreeToggle<CR>',                                                                 desc = 'Undo tree',                nowait = false,    remap = false },
    })
  end,
}

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
      { '<leader>;',       '<cmd>lua Snacks.dashboard()<CR>',                                                         desc = 'Dashboard',                nowait = false,    remap = false },
      { '<leader><s-tab>', hidden = true,                                                                             nowait = false,                    remap = false },
      { '<leader><tab>',   hidden = true,                                                                             nowait = false,                    remap = false },
      { '<leader>a',       '<cmd>wa<CR>',                                                                             desc = 'Save All',                 nowait = false,    remap = false },

      { '<leader>A',       group = 'AutoRun' },
      { '<leader>Ar',      '<cmd>AutoRun<CR>',                                                                        desc = 'Run',                      nowait = false,    remap = false },
      { '<leader>As',      '<cmd>AutoRunStop<CR>',                                                                    desc = 'Stop',                     nowait = false,    remap = false },

      { '<leader>c',       group = 'QuickFix',                                                                        nowait = false,                    remap = false },
      { '<leader>bd',      '<cmd>lua Snacks.bufdelete.delete()<CR>',                                                  desc = 'Delete buffer',            nowait = false,    remap = false },
      { '<leader>ba',      '<cmd>lua Snacks.bufdelete.all()<CR>',                                                     desc = 'Delete all buffers',       nowait = false,    remap = false },
      { '<leader>bn',      '<cmd>lua Snacks.notify.info("Buffer "..vim.api.nvim_get_current_buf())<CR>',              desc = 'Show number',              nowait = false,    remap = false },

      { '<leader>c',       group = 'QuickFix',                                                                        nowait = false,                    remap = false },
      { '<leader>cc',      '<cmd>cclose<CR>',                                                                         desc = 'Close',                    nowait = false,    remap = false },
      { '<leader>cn',      '<cmd>cnext<CR>',                                                                          desc = 'Next',                     nowait = false,    remap = false },
      { '<leader>co',      '<cmd>copen<CR>',                                                                          desc = 'Open',                     nowait = false,    remap = false },
      { '<leader>cp',      '<cmd>cprev<CR>',                                                                          desc = 'Previous',                 nowait = false,    remap = false },

      { '<leader>d',       group = 'Debug',                                                                           nowait = false,                    remap = false },
      { '<leader>dB',      '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',        desc = 'Conditional breakpoint',   nowait = false,    remap = false },
      { '<leader>dC',      '<cmd>lua require"dap".clear_breakpoints()<CR>',                                           desc = 'Clear breakpoints',        nowait = false,    remap = false },
      { '<leader>dO',      '<cmd>lua require"dap".step_out()<CR>',                                                    desc = 'Step out',                 nowait = false,    remap = false },
      { '<leader>db',      '<cmd>lua require"dap".toggle_breakpoint()<CR>',                                           desc = 'Toggle breakpoint',        nowait = false,    remap = false },
      { '<leader>dc',      '<cmd>lua require"dap".continue()<CR>',                                                    desc = 'Start/continue',           nowait = false,    remap = false },
      { '<leader>di',      '<cmd>lua require"dap".step_into()<CR>',                                                   desc = 'Step into',                nowait = false,    remap = false },
      { '<leader>dl',      '<cmd>lua require"dap".run_last()<CR>',                                                    desc = 'Last',                     nowait = false,    remap = false },
      { '<leader>dm',      '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', desc = 'Message',                  nowait = false,    remap = false },
      { '<leader>do',      '<cmd>lua require"dap".step_over()<CR>',                                                   desc = 'Step over',                nowait = false,    remap = false },
      { '<leader>dr',      '<cmd>lua require"dap".repl.open()<CR>',                                                   desc = 'REPL',                     nowait = false,    remap = false },
      { '<leader>dx',      '<cmd>lua require"dap".disconnect()<CR>',                                                  desc = 'Exit',                     nowait = false,    remap = false },
      { '<leader>de',      '<cmd>lua require("dapui").eval()<CR>',                                                    mode = { 'n', 'v' },               desc = 'Evaluate', nowait = false, remap = false },

      { '<leader>e',       '<cmd>Yazi<CR>',                                                                           desc = 'Explorer',                 nowait = false,    remap = false },

      { '<leader>f',       group = 'Find',                                                                            nowait = false,                    remap = false },
      { '<leader>fS',      '<cmd>Telescope search_history<CR>',                                                       desc = 'Search History',           nowait = false,    remap = false },
      { '<leader>fb',      '<cmd>Telescope buffers<CR>',                                                              desc = 'Buffer',                   nowait = false,    remap = false },
      { '<leader>fc',      '<cmd>Telescope command_history<CR>',                                                      desc = 'Command History',          nowait = false,    remap = false },
      { '<leader>fC',      '<cmd>:lua require("telescope.builtin").find_files{ cwd = vim.fn.stdpath("config") }<CR>', desc = 'Command History',          nowait = false,    remap = false },
      { '<leader>ff',      '<cmd>Telescope find_files<CR>',                                                           desc = 'File',                     nowait = false,    remap = false },
      { '<leader>fg',      '<cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>',              desc = 'Grep',                     nowait = false,    remap = false },
      { '<leader>fl',      '<cmd>Telescope resume<CR>',                                                               desc = 'Last Query',               nowait = false,    remap = false },
      { '<leader>fm',      '<cmd>Telescope marks<CR>',                                                                desc = 'Marks',                    nowait = false,    remap = false },
      { '<leader>fh',      '<cmd>Telescope help_tags<CR>',                                                            desc = 'Help',                     nowait = false,    remap = false },
      { '<leader>fp',      '<cmd>lua require("spectre").open_visual()<CR>',                                           desc = 'Project',                  nowait = false,    remap = false },
      { '<leader>fq',      '<cmd>Telescope quickfix<CR>',                                                             desc = 'QuickFix',                 nowait = false,    remap = false },
      { '<leader>fr',      '<cmd>Telescope oldfiles<CR>',                                                             desc = 'Recent',                   nowait = false,    remap = false },
      { '<leader>fs',      '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',                                        desc = 'Symbols',                  nowait = false,    remap = false },
      { '<leader>ft',      "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",            desc = 'Text',                     nowait = false,    remap = false },
      { '<leader>fw',      '<cmd>Telescope grep_string<CR>',                                                          desc = 'Word under cursor',        nowait = false,    remap = false },

      { '<leader>d',       group = 'Git',                                                                             nowait = false,                    remap = false },
      { '<leader>go',      '<cmd>lua Snacks.lazygit()<CR>',                                                           desc = 'LazyGit',                  nowait = false,    remap = false },
      { '<leader>gb',      '<cmd>lua Snacks.git.blame_line()<CR>',                                                    desc = 'Blame',                    nowait = false,    remap = false },
      { '<leader>gx',      '<cmd>lua Snacks.gitbrowse()<CR>',                                                         desc = 'Open repo',                nowait = false,    remap = false },

      { '<leader>h',       group = 'Harpoon',                                                                         nowait = false,                    remap = false },
      { '<leader>ha',      '<cmd>lua require("harpoon.mark").add_file()<CR>',                                         desc = 'Add Mark',                 nowait = false,    remap = false },
      { '<leader>he',      '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',                                  desc = 'Show Marks',               nowait = false,    remap = false },
      { '<leader>hn',      '<cmd>lua require("harpoon.ui").nav_next()<CR>',                                           desc = 'Next',                     nowait = false,    remap = false },
      { '<leader>hp',      '<cmd>lua require("harpoon.ui").nav_prev()<CR>',                                           desc = 'Prev',                     nowait = false,    remap = false },
      { '<leader>hs',      '<cmd>Telescope harpoon marks<CR>',                                                        desc = 'Search',                   nowait = false,    remap = false },
      { '<leader>j',       '<cmd>silent !tmux neww ff<CR>',                                                           desc = 'Manage feature flags',     nowait = false,    remap = false },

      { '<leader>l',       group = 'LSP',                                                                             nowait = false,                    remap = false },
      { '<leader>l/',      '<cmd>LspInfo<CR>',                                                                        desc = 'Info',                     nowait = false,    remap = false },
      { '<leader>l?',      '<cmd>Mason<CR>',                                                                          desc = 'Server Info',              nowait = false,    remap = false },
      { '<leader>lF',      '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',                                       desc = 'Format',                   nowait = false,    remap = false },
      { '<leader>ld',      '<cmd>Telescope lsp_definitions<CR>',                                                      desc = 'Goto Definition',          nowait = false,    remap = false },
      { '<leader>lf',      '<cmd>Telescope lsp_references<CR>',                                                       desc = 'References',               nowait = false,    remap = false },
      { '<leader>lh',      '<cmd>lua vim.lsp.buf.hover()<CR>',                                                        desc = 'Hover',                    nowait = false,    remap = false },
      { '<leader>ll',      '<cmd>lua vim.diagnostic.open_float()<CR>',                                                desc = 'Line Diagnostic',          nowait = false,    remap = false },
      { '<leader>lr',      '<cmd>lua vim.lsp.buf.rename()<CR>',                                                       desc = 'Rename',                   nowait = false,    remap = false },
      { '<leader>ls',      '<cmd>Telescope lsp_document_symbols<CR>',                                                 desc = 'Symbols',                  nowait = false,    remap = false },
      { '<leader>lt',      '<cmd>Telescope lsp_type_definitions<CR>',                                                 desc = 'Goto Type Definition',     nowait = false,    remap = false },
      { '<leader>lv',      '<cmd>vsplit | Telescope lsp_definitions<CR>',                                             desc = 'Goto Definition in split', nowait = false,    remap = false },
      { '<leader>lx',      '<cmd>LspRestart<CR>',                                                                     desc = 'Restart',                  nowait = false,    remap = false },

      { '<leader>m',       '<cmd>Telescope tmux_sessionizer<CR>',                                                     desc = 'Change repo',              nowait = false,    remap = false },

      { '<leader>n',       group = 'Notifications',                                                                   nowait = false,                    remap = false },
      { '<leader>nh',      '<cmd>lua Snacks.notifier.show_history()<CR>',                                             desc = 'History',                  nowait = false,    remap = false },
      { '<leader>nx',      '<cmd>lua Snacks.notifier.hide()<CR>',                                                     desc = 'Clear',                    nowait = false,    remap = false },

      { '<leader>p',       '<cmd>Lazy<CR>',                                                                           desc = 'Plugins',                  nowait = false,    remap = false },
      { '<leader>P',       '<cmd>Prettier<CR>',                                                                       desc = 'Prettier',                 nowait = false,    remap = false },
      { '<leader>q',       '<cmd>q<CR>',                                                                              desc = 'Quit',                     nowait = false,    remap = false },
      { '<leader>r',       '<cmd>GrugFar ripgrep<CR>',                                                                desc = 'Replace',                  nowait = false,    remap = false },

      { '<leader>t',       group = 'Terminal',                                                                        nowait = false,                    remap = false },
      { '<leader>t.',      '<cmd>term<CR>',                                                                           desc = 'Here',                     nowait = false,    remap = false },
      { '<leader>ts',      '<cmd>split term://zsh | :startinsert<CR>',                                                desc = 'Horizontal split',         nowait = false,    remap = false },
      { '<leader>tt',      '<cmd>tabnew | :edit term://zsh | :startinsert<CR>',                                       desc = 'Tab',                      nowait = false,    remap = false },
      { '<leader>tv',      '<cmd>vsplit term://zsh | :startinsert<CR>',                                               desc = 'Vert split',               nowait = false,    remap = false },
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

-- vim:foldmethod=marker:foldmarker={-{,}-}
-- INIT {-{
local fn = vim.fn
local execute = vim.api.nvim_command
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " ..
                install_path)
    execute "packadd packer.nvim"
end

-- recompile on change
vim.cmd([[
    augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

require("packer").startup({
    function(use)

        -- Packer can manage itself
        use "wbthomason/packer.nvim"

        use "neovim/nvim-lspconfig"
        use "tami5/lspsaga.nvim"
        use "williamboman/nvim-lsp-installer"
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/nvim-cmp"
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use "windwp/nvim-ts-autotag"
        use "windwp/nvim-autopairs"
        use "folke/which-key.nvim"
        use "folke/tokyonight.nvim"
        use "kdheepak/lazygit.nvim"
        use {"lewis6991/gitsigns.nvim", requires = {'nvim-lua/plenary.nvim'}}
        use "karb94/neoscroll.nvim"
        use "glepnir/galaxyline.nvim"
        use "goolord/alpha-nvim"
        use "shatur/neovim-session-manager"
        use "kevinhwang91/nvim-bqf"
        use "brooth/far.vim"
        use "embear/vim-localvimrc"
        use 'b3nj5m1n/kommentary'
        use "f-person/git-blame.nvim"
        use {
            "kyazdani42/nvim-tree.lua",
            requires = "kyazdani42/nvim-web-devicons"
        }
        use {"nikvdp/neomux", requires = "kyazdani42/nvim-web-devicons"}
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-telescope/telescope-fzy-native.nvim",
                "nvim-lua/plenary.nvim"
            }
        }

    end,
    config = {
        compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
        display = {open_fn = require("packer.util").float}
    }
})
-- }-}

-- ALPHA {-{
local startify = require 'alpha.themes.startify'
startify.nvim_web_devicons.enabled = true
startify.section.top_buttons.val = {
    startify.button("t", "🖳 Terminal", ":call NeomuxTerm()<CR>"),
    startify.button("s", "🖫 Load Session", ":Telescope sessions<CR>"),
    startify.button("e", "🗋 New", ":enew <CR>")
}

require'alpha'.setup(startify.opts)
-- }-}

-- AUTOPAIRS {-{
require'nvim-autopairs'.setup {}
-- }-}

-- CMP {-{
local cmp = require 'cmp'

cmp.setup({
    snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
    mapping = {
        ['<Up>'] = cmp.mapping.scroll_docs(-4),
        ['<Down>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-c>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
        }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
        })
    },
    sources = {
        {name = 'nvim_lsp'}, {name = "treesitter"}, {name = 'vsnip'},
        {name = 'buffer'}, {name = "path"}, {
            name = "buffer",
            opts = {get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end}
        }
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "ﲳ",
                nvim_lua = "",
                treesitter = "",
                path = "ﱮ",
                buffer = "﬘",
                zsh = "",
                vsnip = "",
                spell = "暈"
            })[entry.source.name]

            return vim_item
        end
    }
})

require("nvim-autopairs.completion.cmp").setup({
    map_cr = true,
    map_complete = true,
    auto_select = true,
    insert = false,
    map_char = {all = '(', tex = '{'}
})
-- }-}

-- GALAXYLINE {-{
local gl = require('galaxyline')
-- get my theme in galaxyline repo
local colors = {
    bg = '#1f2335',
    yellow = '#e0af68',
    dark_yellow = '#41a6b5',
    cyan = '#7dcfff',
    green = '#9ece6a',
    light_green = '#73daca',
    string_orange = '#f7768e',
    orange = '#ff9e64',
    purple = '#9d7cd8',
    magenta = '#bb9af7',
    grey = '#a9b1d6',
    blue = '#7aa2f7',
    vivid_blue = '#0db9d7',
    light_blue = '#2ac3de',
    red = '#f7768e',
    error_red = '#db4b4b',
    info_yellow = '#c0caf5'
}
-- local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree', 'vista', 'dbui', 'packer'}

gls.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color according the vim mode
            local mode_color = {
                n = colors.green,
                i = colors.blue,
                v = colors.purple,
                [''] = colors.purple,
                V = colors.purple,
                c = colors.magenta,
                no = colors.blue,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.red,
                Rv = colors.red,
                cv = colors.blue,
                ce = colors.blue,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.blue,
                t = colors.blue
            }
            vim.api.nvim_command('hi GalaxyViMode guifg=' ..
                                     mode_color[vim.fn.mode()])
            return '▊ '
        end,
        highlight = {colors.red, colors.bg}
    }
}
print(vim.fn.getbufvar(0, 'ts'))
vim.fn.getbufvar(0, 'ts')

local winNum = {
    WinNum = {
        provider = function()
            return "W:" .. vim.api.nvim_win_get_number(0) .. " "
        end,
        separator = ' ',
        highlight = {colors.grey, colors.bg}
    }
}

gls.left[2] = {
    GitIcon = {
        provider = function() return ' ' end,
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.orange, colors.bg}
    }
}

gls.left[3] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.left[4] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = condition.hide_in_width,
        icon = '  ',
        highlight = {colors.green, colors.bg}
    }
}
gls.left[5] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = condition.hide_in_width,
        icon = ' 柳',
        highlight = {colors.blue, colors.bg}
    }
}
gls.left[6] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = condition.hide_in_width,
        icon = '  ',
        highlight = {colors.red, colors.bg}
    }
}

gls.left[7] = {
    Modified = {
        provider = function()
            if vim.api.nvim_buf_get_option(0, 'modified') == true then
                return '+'
            end
        end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.right[1] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.error_red, colors.bg}
    }
}
gls.right[2] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = {colors.orange, colors.bg}
    }
}

gls.right[3] = {
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ',
        highlight = {colors.vivid_blue, colors.bg}
    }
}

gls.right[4] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = {colors.info_yellow, colors.bg}
    }
}

gls.right[5] = {
    ShowLspClient = {
        provider = 'GetLspClient',
        condition = function()
            local tbl = {['dashboard'] = true, [' '] = true}
            if tbl[vim.bo.filetype] then return false end
            return true
        end,
        icon = '  ',
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[6] = {
    LineInfo = {
        provider = 'LineColumn',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[7] = {
    PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[8] = {
    Tabstop = {
        provider = function()
            return "Spaces:" .. vim.api.nvim_buf_get_option(0, "shiftwidth") ..
                       " "
        end,
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[10] = {
    BufferType = {
        provider = 'FileTypeName',
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[11] = {
    FileEncode = {
        provider = 'FileEncode',
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[12] = {
    Space = {
        provider = function() return ' ' end,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.orange, colors.bg}
    }
}

gls.right[13] = winNum

gls.short_line_left[1] = {
    BufferType = {
        provider = 'FileTypeName',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.short_line_left[2] = {
    SFileName = {
        provider = 'SFileName',
        condition = condition.buffer_not_empty,
        highlight = {colors.grey, colors.bg}
    }
}

gls.short_line_right[1] = winNum
-- }-}

-- GITSIGNS {-{
require('gitsigns').setup {
    signs = {
        -- TODO add hl to colorscheme
        add = {
            hl = 'GitSignsAdd',
            text = '▎',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            hl = 'GitSignsChange',
            text = '▎',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            hl = 'GitSignsDelete',
            text = '契',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '契',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            hl = 'GitSignsChange',
            text = '▎',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        }
    },
    numhl = false,
    linehl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true
    },
    watch_gitdir = {interval = 1000},
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil -- Use default
}
-- }-}

-- LSPSAGA {-{
local lspsaga = require 'lspsaga'
lspsaga.setup { -- defaults ...
    debug = false,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    diagnostic_header_icon = "   ",
    -- code action title icon
    code_action_icon = " ",
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false
    },
    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        open = "o",
        vsplit = "v",
        split = "s",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>"
    },
    code_action_keys = {quit = "q", exec = "<CR>"},
    rename_action_keys = {quit = "<C-c>", exec = "<CR>"},
    definition_preview_icon = "  ",
    border_style = "single",
    rename_prompt_prefix = "➤",
    server_filetype_map = {}
}
-- }-}

-- NEOMUX  {-{
vim.g.neomux_start_term_map = "<Leader>t."
vim.g.neomux_exit_term_mode_map = "<C-space>"
vim.g.neomux_start_term_split_map = "<Leader>ts"
vim.g.neomux_start_term_vsplit_map = "<Leader>tv"
vim.g.neomux_no_term_autoinsert = 1
-- }-}

-- NEOSCROLL  {-{
require('neoscroll').setup({
    easing = true,
    cursor_scrolls_alone = true,
    hide_cursor = false
})
-- }-}

-- NVIM-TREE  {-{
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
        unstaged = "",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = ""
    },
    folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = ""
    }
}

require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    auto_close = true,
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {enable = true, update_cwd = false, ignore_list = {}},
    system_open = {cmd = nil, args = {}},
    view = {
        mappings = {
            list = {
                {
                    key = {"<CR>", "o", "l", "<2-LeftMouse>"},
                    cb = tree_cb("edit")
                }, {key = {"<2-RightMouse>", "cd"}, cb = tree_cb("cd")},
                {key = {"<BS>", "h"}, cb = tree_cb("close_node")},
                {key = "v", cb = tree_cb("vsplit")},
                {key = "s", cb = tree_cb("split")},
                {key = "<C-t>", cb = tree_cb("tabnew")},
                {key = "<", cb = tree_cb("prev_sibling")},
                {key = ">", cb = tree_cb("next_sibling")},
                {key = "<S-CR>", cb = tree_cb("close_node")},
                {key = "<Tab>", cb = tree_cb("preview")},
                {key = "I", cb = tree_cb("toggle_ignored")},
                {key = "H", cb = tree_cb("toggle_dotfiles")},
                {key = "R", cb = tree_cb("refresh")},
                {key = "a", cb = tree_cb("create")},
                {key = "d", cb = tree_cb("remove")},
                {key = "r", cb = tree_cb("rename")},
                {key = "<C-r>", cb = tree_cb("full_rename")},
                {key = "x", cb = tree_cb("cut")},
                {key = "c", cb = tree_cb("copy")},
                {key = "p", cb = tree_cb("paste")},
                {key = "[c", cb = tree_cb("prev_git_item")},
                {key = "]c", cb = tree_cb("next_git_item")},
                {key = "u", cb = tree_cb("dir_up")},
                {key = "q", cb = tree_cb("close")}
            }
        }
    }
}
-- }-}

-- SESSION-MANAGER  {-{
require('session_manager').setup({
    sessions_dir = require 'plenary.path':new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
    path_replacer = '__', -- The character to which the path separator will be replaced for session files.
    colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
    autoload_last_session = false, -- Automatically load last session on startup is started without arguments.
    autosave_last_session = false, -- Automatically save last session on exit.
    autosave_ignore_paths = {'~'} -- Folders to ignore when autosaving a session.
})
-- }-}

-- TELESCOPE  {-{
local actions = require('telescope.actions')

require'telescope'.setup {
    defaults = {
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        mappings = {
            i = {
                ["<C-c>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-s>"] = actions.select_horizontal,
                ["<CR>"] = actions.select_default + actions.center
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        }
    }
}

require('telescope').load_extension('sessions')
-- }-}

-- TREESITTER  {-{
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    indent = {enable = true},
    autotag = {enable = true},
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner"
            }
        }
    }
}
-- }-}

-- WHICH-KEY  {-{
local wk = require "which-key"
wk.setup {
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it"s label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "} -- hide mapping boilerplate
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local mappings = {
    e = {":NvimTreeToggle<CR>", "Explorer"},
    w = {":w<CR>", "Save"},
    a = {":wa<CR>", "Save All"},
    q = {":q<CR>", "Quit"},
    T = {":tabnew<CR>", "New Tab"},
    [";"] = {"<cmd>Alpha<CR>", "Dashboard"},
    t = {
        name = "+Terminal",
        t = {":tabnew | :call NeomuxTerm()<CR>", "Tab"},
        ["."] = "Here",
        s = "Split",
        v = "Vert split",
        f = {"<cmd>Lspsaga open_floaterm<CR>", "Float"},
        x = {"<cmd>Lspsaga close_floaterm<CR>", "Float"}
    },
    g = {":LazyGit<CR>", "Git"},
    f = {
        name = "+Find",
        f = {"<cmd>Telescope find_files<CR>", "File"},
        b = {"<cmd>Telescope buffers<CR>", "Buffer"},
        r = {"<cmd>Telescope oldfiles<CR>", "Recent"},
        t = {"<cmd>Telescope live_grep<CR>", "Text"},
        l = {"<cmd>Telescope loclist<CR>", "Loclist"},
        q = {"<cmd>Telescope quickfix<CR>", "QuickFix"},
        m = {"<cmd>Telescope marks<CR>", "Marks"},
        s = {"<cmd>Telescope search_history<CR>", "Search History"},
        c = {"<cmd>Telescope command_history<CR>", "Command History"},
        h = {"<cmd>Telescope help_tags<CR>", "Help"}
    },
    x = {":source $HOME/.config/nvim/init.lua<CR>", "Source Config"},
    S = {
        name = "+Session",
        s = {"<cmd>SaveSession<CR>", "Save Session"},
        l = {"<cmd>Telescope sessions<CR>", "Load Session"}
    },
    l = {
        name = "+LSP",
        L = {"<cmd>lua vim.diagnostic.setloclist()<CR>", "To Loclist"},
        f = {"<cmd>Lspsaga lsp_finder<CR>", "Finder"},
        a = {"<cmd>Lspsaga code_action<CR>", "Action"},
        l = {"<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostic"},
        d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
        h = {"<cmd>Lspsaga hover_doc<CR>", "Hover"},
        p = {"<cmd>Lspsaga preview_definition<CR>", "Preview Definition"},
        r = {"<cmd>Lspsaga rename<CR>", "Rename"},
        F = {"<cmd>lua vim.lsp.buf.formatting()<CR>", "Format"},
        ["/"] = {"<cmd>LspInfo<CR>", "Info"},
        ["?"] = {"<cmd>LspInstallInfo<CR>", "Server Info"}
    }
};

wk.register(mappings, opts)
-- }-}
--

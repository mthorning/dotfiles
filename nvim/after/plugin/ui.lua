vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_italic_keywords = 0
vim.cmd("colorscheme tokyonight-moon")

require('gitsigns').setup {}

local startify = require 'alpha.themes.startify'

startify.nvim_web_devicons.enabled = true
startify.section.top_buttons.val = {
    startify.button('t', 'Terminal', ':call NeomuxTerm()<CR>', {}),
    startify.button('e', 'New', ':enew <CR>', {})
}

require'alpha'.setup(startify.opts)

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

local Event = require('nvim-tree.api').events.Event
local api = require('nvim-tree.api')

api.events.subscribe(Event.FileCreated,
                     function(data) api.tree.open(data.fname) end)

require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = true,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {enable = true, update_cwd = false, ignore_list = {}},
    system_open = {cmd = nil, args = {}},
    git = {enable = true, ignore = false},
    actions = {open_file = {quit_on_open = true}},
    view = {
        mappings = {
            list = {
                {
                    key = {'<CR>', 'o', 'l', '<2-LeftMouse>'},
                    cb = tree_cb('edit')
                }, {key = {'<2-RightMouse>', 'c'}, cb = tree_cb('cd')},
                {key = {'<BS>', 'h'}, cb = tree_cb('close_node')},
                {key = 'v', cb = tree_cb('vsplit')},
                {key = 's', cb = tree_cb('split')},
                {key = '<C-t>', cb = tree_cb('tabnew')},
                {key = '<', cb = tree_cb('prev_sibling')},
                {key = '>', cb = tree_cb('next_sibling')},
                {key = '<S-CR>', cb = tree_cb('close_node')},
                {key = '<Tab>', cb = tree_cb('preview')},
                {key = 'I', cb = tree_cb('toggle_ignored')},
                {key = 'H', cb = tree_cb('toggle_dotfiles')},
                {key = 'R', cb = tree_cb('refresh')},
                {key = 'a', cb = tree_cb('create')},
                {key = 'd', cb = tree_cb('remove')},
                {key = 'r', cb = tree_cb('rename')},
                {key = '<C-r>', cb = tree_cb('full_rename')},
                {key = 'x', cb = tree_cb('cut')},
                {key = 'y', cb = tree_cb('copy')},
                {key = 'p', cb = tree_cb('paste')},
                {key = '[c', cb = tree_cb('prev_git_item')},
                {key = ']c', cb = tree_cb('next_git_item')},
                {key = 'u', cb = tree_cb('dir_up')},
                {key = 'q', cb = tree_cb('close')},
                {key = 'g?', cb = tree_cb('toggle_help')}
            }
        }
    },
    renderer = {
        icons = {
            glyphs = {
                default = '',
                symlink = '',
                git = {
                    unstaged = '',
                    staged = '✓',
                    unmerged = '',
                    renamed = '➜',
                    untracked = ''
                },
                folder = {
                    default = '',
                    open = '',
                    empty = '',
                    empty_open = '',
                    symlink = ''
                }
            }
        }
    }
}

local file_component = {'filename', path = 1, shorting_target = 40}
local function buf_num() return vim.api.nvim_get_current_buf() end

require('lualine').setup {
    tabline = {
        lualine_a = {'tabs'},
        lualine_x = {'diff', 'diagnostics'},
        lualine_y = {},
        lualine_z = {'branch'}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {buf_num},
        lualine_c = {file_component},
        lualine_x = {'fileformat', 'filetype', 'buffer'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {buf_num},
        lualine_c = {file_component},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    }
}

require('neoscroll').setup()

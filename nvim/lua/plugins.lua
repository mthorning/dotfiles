-- vim:foldmethod=marker:foldmarker={-{,}-}
-- init {-{
local fn = vim.fn
local execute = vim.api.nvim_command
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
    install_path)
  execute 'packadd packer.nvim'
end

-- recompile on change
vim.cmd([[
    augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

require('packer').startup({
  function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'
    use 'tami5/lspsaga.nvim'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/nvim-cmp'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'windwp/nvim-ts-autotag'
    use 'windwp/nvim-autopairs'
    use 'folke/which-key.nvim'
    use 'folke/tokyonight.nvim'
    use 'kdheepak/lazygit.nvim'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use 'karb94/neoscroll.nvim'
    -- use 'glepnir/galaxyline.nvim'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'goolord/alpha-nvim'
    use 'shatur/neovim-session-manager'
    use 'kevinhwang91/nvim-bqf'
    use 'brooth/far.vim'
    use 'embear/vim-localvimrc'
    use 'b3nj5m1n/kommentary'
    use 'f-person/git-blame.nvim'
    use 'justinmk/vim-sneak'
    use 'RRethy/vim-illuminate'
    use 'tpope/vim-fugitive'
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons'
    }
    use { 'nikvdp/neomux', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim' }
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-live-grep-raw.nvim'
      }
    }
    use 'github/copilot.vim'

  end,
  config = {
    compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    display = { open_fn = require('packer.util').float }
  }
})
-- }-}

-- Alpha {-{
local startify = require 'alpha.themes.startify'
startify.nvim_web_devicons.enabled = true
startify.section.top_buttons.val = {
  startify.button('t', 'Terminal', ':call NeomuxTerm()<CR>', {}),
  startify.button('s', 'Load Session', ':Telescope sessions<CR>', {}),
  startify.button('e', 'New', ':enew <CR>', {})
}

require 'alpha'.setup(startify.opts)
-- }-}

-- Cmp {-{
local cmp = require 'cmp'

cmp.setup({
  snippet = { expand = function(args) vim.fn['vsnip#anonymous'](args.body) end },
  mapping = {
    ['<Up>'] = cmp.mapping.scroll_docs(-4),
    ['<Down>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping.close(),
    ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert
    }),
    ['<C-p>'] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert
    })
  },
  sources = {
    { name = 'vsnip' }, { name = 'nvim_lsp' }, { name = 'treesitter' },
    { name = 'buffer' }, { name = 'path' }, {
      name = 'buffer',
      options = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    }
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = 'ﲳ',
        nvim_lua = '',
        treesitter = '',
        path = 'ﱮ',
        buffer = '﬘',
        zsh = '',
        vsnip = '',
        spell = '暈'
      })[entry.source.name]

      return vim_item
    end
  }
})

-- Vsnip mappings
vim.cmd([[
  imap <expr> <C-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>'
  smap <expr> <C-n>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-n>'

  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])

-- }-}

-- Autopairs {-{
require 'nvim-autopairs'.setup {}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({
  map_cr = true,
  map_complete = true,
  auto_select = true,
  insert = false,
  map_char = { all = '(', tex = '{' }
}))
-- }-}

-- Gitsigns {-{
require('gitsigns').setup {
  --[[ signs = {
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
            text = '⤵',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '⤴',
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
    status_formatter = nil -- Use default ]]
}
-- }-}

-- Lspsaga {-{
local lspsaga = require 'lspsaga'
lspsaga.setup { -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = 'X',
  warn_sign = '⚠',
  hint_sign = '?',
  infor_sign = 'ℹ',
  diagnostic_header_icon = ' ',
  -- code action title icon
  code_action_icon = ' ',
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = false
  },
  finder_definition_icon = ' ',
  finder_reference_icon = ' ',
  max_preview_lines = 10,
  finder_action_keys = {
    open = 'o',
    vsplit = 'v',
    split = 's',
    quit = 'q',
    scroll_down = '<C-f>',
    scroll_up = '<C-b>'
  },
  code_action_keys = { quit = 'q', exec = '<CR>' },
  rename_action_keys = { quit = '<C-c>', exec = '<CR>' },
  definition_preview_icon = '  ',
  border_style = 'single',
  rename_prompt_prefix = '➤',
  server_filetype_map = {}
}
-- }-}

-- Neomux  {-{
vim.g.neomux_start_term_map = '<Leader>t.'
vim.g.neomux_exit_term_mode_map = '<C-space>'
vim.g.neomux_start_term_split_map = '<Leader>ts'
vim.g.neomux_start_term_vsplit_map = '<Leader>tv'
vim.g.neomux_no_term_autoinsert = 1
-- }-}

-- Lualine {-{
local file_component = { 'filename', path = 1, shorting_target = 40 }
require('lualine').setup {
  tabline = {
    lualine_a = { 'tabs' },
    lualine_x = { 'diff', 'diagnostics' },
    lualine_y = {},
    lualine_z = { 'branch' }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = { file_component },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { file_component },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  }
}
-- }-}

-- Neoscroll  {-{
require('neoscroll').setup({
  easing = true,
  cursor_scrolls_alone = true,
  hide_cursor = false
})
-- }-}

-- Nvim-Tree  {-{
local tree_cb = require 'nvim-tree.config'.nvim_tree_callback

require 'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = true,
  update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
  system_open = { cmd = nil, args = {} },
  git = { enable = true, ignore = false },
  actions = { open_file = { quit_on_open = true } },
  view = {
    mappings = {
      list = {
        {
          key = { '<CR>', 'o', 'l', '<2-LeftMouse>' },
          cb = tree_cb('edit')
        }, { key = { '<2-RightMouse>', 'c' }, cb = tree_cb('cd') },
        { key = { '<BS>', 'h' }, cb = tree_cb('close_node') },
        { key = 'v', cb = tree_cb('vsplit') },
        { key = 's', cb = tree_cb('split') },
        { key = '<C-t>', cb = tree_cb('tabnew') },
        { key = '<', cb = tree_cb('prev_sibling') },
        { key = '>', cb = tree_cb('next_sibling') },
        { key = '<S-CR>', cb = tree_cb('close_node') },
        { key = '<Tab>', cb = tree_cb('preview') },
        { key = 'I', cb = tree_cb('toggle_ignored') },
        { key = 'H', cb = tree_cb('toggle_dotfiles') },
        { key = 'R', cb = tree_cb('refresh') },
        { key = 'a', cb = tree_cb('create') },
        { key = 'd', cb = tree_cb('remove') },
        { key = 'r', cb = tree_cb('rename') },
        { key = '<C-r>', cb = tree_cb('full_rename') },
        { key = 'x', cb = tree_cb('cut') },
        { key = 'y', cb = tree_cb('copy') },
        { key = 'p', cb = tree_cb('paste') },
        { key = '[c', cb = tree_cb('prev_git_item') },
        { key = ']c', cb = tree_cb('next_git_item') },
        { key = 'u', cb = tree_cb('dir_up') },
        { key = 'q', cb = tree_cb('close') },
        { key = 'g?', cb = tree_cb('toggle_help') }
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
-- }-}

-- Session-Manager  {-{
require('session_manager').setup({
  sessions_dir = require 'plenary.path':new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
  autosave_last_session = false, -- Automatically save last session on exit.
  autosave_ignore_paths = { '~' } -- Folders to ignore when autosaving a session.
})
-- }-}

-- Telescope  {-{
local actions = require('telescope.actions')

require 'telescope'.setup {
  defaults = {
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'horizontal',
    file_ignore_patterns = { "node_modules", ".git" },
    mappings = {
      i = {
        ['<C-c>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<C-s>'] = actions.select_horizontal,
        ['<CR>'] = actions.select_default + actions.center
      },
      n = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist
      }
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true
    }
  },
  pickers = { find_files = { hidden = true } }
}
-- }-}

-- Treesitter  {-{
require 'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  ignore_install = { "phpdoc", "c", "haskell" },
  autotag = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner'
      }
    }
  }
}
-- }-}

-- Which-Key  {-{
local wk = require 'which-key'
wk.setup {
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+' -- symbol prepended to a group
  },
  window = {
    border = 'single', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 } -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3 -- spacing between columns
  },
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' } -- hide mapping boilerplate
}

local opts = {
  mode = 'n', -- NORMAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false -- use `nowait` when creating keymaps
}

local mappings = {
  e = { ':NvimTreeToggle<CR>', 'Explorer' },
  w = { ':w<CR>', 'Save' },
  a = { ':wa<CR>', 'Save All' },
  q = { ':q<CR>', 'Quit' },
  T = { ':tabnew<CR>', 'New Tab' },
  [';'] = { '<cmd>Alpha<CR>', 'Dashboard' },
  t = {
    name = '+Terminal',
    t = { ':tabnew | :call NeomuxTerm()<CR>', 'Tab' },
    ['.'] = 'Here',
    s = 'Split',
    v = 'Vert split',
    f = { '<cmd>Lspsaga open_floaterm<CR>', 'Float' },
    x = { '<cmd>Lspsaga close_floaterm<CR>', 'Float' }
  },
  c = {
    name = '+QuickFix',
    c = { ':cclose<CR>', 'Close' },
    o = { ':copen<CR>', 'Open' },
    n = { ':cnext<CR>', 'Next' },
    p = { ':cprev<CR>', 'Previous' }
  },
  g = { ':LazyGit<CR>', 'Git' },
  f = {
    name = '+Find',
    f = { '<cmd>Telescope find_files<CR>', 'File' },
    b = { '<cmd>Telescope buffers<CR>', 'Buffer' },
    r = { '<cmd>Telescope oldfiles<CR>', 'Recent' },
    t = { '<cmd>Telescope live_grep<CR>', 'Text' },
    g = {
      '<cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>',
      'Grep'
    },
    l = { '<cmd>Telescope loclist<CR>', 'Loclist' },
    q = { '<cmd>Telescope quickfix<CR>', 'QuickFix' },
    m = { '<cmd>Telescope marks<CR>', 'Marks' },
    s = { '<cmd>Telescope search_history<CR>', 'Search History' },
    c = { '<cmd>Telescope command_history<CR>', 'Command History' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help' }
  },
  x = { ':silent !chmod +x %<CR>', 'Make Executable' },
  S = {
    name = '+Session',
    s = { '<cmd>SaveSession<CR>', 'Save Session' },
    l = { '<cmd>Telescope sessions<CR>', 'Load Session' }
  },
  l = {
    name = '+LSP',
    L = { '<cmd>lua vim.diagnostic.setloclist()<CR>', 'To Loclist' },
    f = { '<cmd>Lspsaga lsp_finder<CR>', 'Finder' },
    a = { '<cmd>Lspsaga code_action<CR>', 'Action' },
    l = { '<cmd>Lspsaga show_line_diagnostics<CR>', 'Line Diagnostic' },
    d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Goto Definition' },
    h = { '<cmd>Lspsaga hover_doc<CR>', 'Hover' },
    p = { '<cmd>Lspsaga preview_definition<CR>', 'Preview Definition' },
    r = { '<cmd>Lspsaga rename<CR>', 'Rename' },
    F = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' },
    ['/'] = { '<cmd>LspInfo<CR>', 'Info' },
    ['?'] = { '<cmd>LspInstallInfo<CR>', 'Server Info' }
  },
  h = {
    name = '+Harpoon',
    a = { '<cmd>lua require("harpoon.mark").add_file()<CR>', 'Add Mark' },
    e = {
      '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',
      'Show Marks'
    },
    ["1"] = { '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', 'Nav Mark 1' },
    ["2"] = { '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', 'Nav Mark 2' },
    ["3"] = { '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', 'Nav Mark 3' },
    ["4"] = { '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', 'Nav Mark 4' }
  },
  m = { ':silent !tmux neww tmux-sessioniser<CR>', 'New Tmux Session' },
  ['<tab>'] = 'which_key_ignore',
  ['<s-tab>'] = 'which_key_ignore',
  ['<'] = 'which_key_ignore'
};

wk.register(mappings, opts)
-- }-}

-- Illuminate {-{
vim.g.illuminate_highlightUnderCursor = 0
-- }-}

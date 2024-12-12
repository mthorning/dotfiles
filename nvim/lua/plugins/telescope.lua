return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  cmd = 'Telescope',
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim" ,
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-raw.nvim'
  },
  config = function()
    local actions = require('telescope.actions')

    require("telescope").setup {
      defaults = {
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'descending',
        layout_strategy = 'horizontal',
        file_ignore_patterns = { "node_modules", ".git" },
        mappings = {
          i = {
            ['<C-c>'] = actions.close,
            ['<C-j>'] = actions.preview_scrolling_down,
            ['<C-k>'] = actions.preview_scrolling_up,
            ['<C-q>'] = actions.smart_send_to_qflist +
            actions.open_qflist,
            ['<C-s>'] = actions.select_horizontal,
            ['<CR>'] = actions.select_default + actions.center
          },
          n = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-q>'] = actions.smart_send_to_qflist +
            actions.open_qflist,
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

    require('telescope').load_extension('harpoon')
    require("telescope").load_extension("tmux_sessionizer")
    require("telescope").load_extension("live_grep_args")
  end
}

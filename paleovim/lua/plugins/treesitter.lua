return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { 'javascript', 'go', 'typescript', 'tsx', 'html', 'css', 'lua' },
        auto_install = true,
        sync_install = false,
        autotag = { enabled = false },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        ignore_install = {},
        modules = {},
        textobjects = {
          -- from treesitter-textobjects
          lsp_interop = {
            enable = true,
            border = 'rounded',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>lp"] = "@function.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,

            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "parameter.inner",
            },
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'BufReadPre',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-ts-autotag'.setup {
        opts = {
          enable_close = false,
          enable_rename = true,
          enable_close_on_slash = true
        },
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter',
    opts = {
      enable = true,
      max_lines = 6,
      trim_scope = 'outer',
      patterns = {
        default = {
          'class', 'function', 'method', 'for', 'while', 'if', 'switch',
          'case'
        },
        rust = { 'impl_item', 'struct', 'enum' },
        markdown = { 'section' },
        json = { 'pair' },
        yaml = { 'block_mapping_pair' }
      },
      exact_patterns = {},
      zindex = 20,
      mode = 'cursor',
      separator = nil
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = 'nvim-treesitter/nvim-treesitter'
  }
}

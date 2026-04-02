return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { 'javascript', 'go', 'typescript', 'tsx', 'html', 'css', 'lua', 'rust' },
        auto_install = true,
        sync_install = false,
        autotag = { enabled = false },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        ignore_install = {},
        modules = {},
        textobjects = {
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
              ["ia"] = "@parameter.inner",
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
    -- enabled = false, -- Uncomment if still broken after :Lazy sync
    opts = {
      enable = true,
      max_lines = 6,
      trim_scope = 'outer',
      zindex = 20,
      mode = 'cursor',
      separator = nil,
      on_attach = function(buf)
        local ft = vim.bo[buf].filetype
        return ft ~= 'markdown'  -- disable for markdown until fixed
      end
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = 'nvim-treesitter/nvim-treesitter'
  }
}

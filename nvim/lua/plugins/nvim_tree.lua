return {
  enabled = false,
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  cmd = 'NvimTreeToggle',
  config = function()
    local function on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
      vim.keymap.set('n', 'c', api.fs.copy.filename, opts('Copy Name'))
    end


    require 'nvim-tree'.setup {
      on_attach = on_attach,
      disable_netrw = false,
      hijack_netrw = false,
      open_on_tab = false,
      hijack_cursor = true,
      update_cwd = true,
      update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
      system_open = { cmd = nil, args = {} },
      git = { enable = true, ignore = false },
      actions = { open_file = { quit_on_open = true } },
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
  end
}

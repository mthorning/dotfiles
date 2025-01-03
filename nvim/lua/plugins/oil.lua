return {
  'stevearc/oil.nvim',
  enabled = false,
  opts = {
    columns = {
      "icon",
      "permissions",
      "size",
      "mtime",
    },
    skip_confirm_for_simple_edits = false,
    keymaps = {
      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-j>"] = "actions.preview_scroll_down",
      ["<C-k>"] = "actions.preview_scroll_up",
      ["q"] = { "actions.close", mode = "n" },
      ["<C-r>"] = "actions.refresh",
      ["h"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
      show_hidden = true,
      case_insensitive = false,
    },
    preview_win = {
      preview_method = "load",
    }
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}

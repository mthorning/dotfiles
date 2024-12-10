return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
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
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}

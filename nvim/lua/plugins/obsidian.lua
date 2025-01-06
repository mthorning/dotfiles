return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    ui = {
      enable = false,
    },
    daily_notes = {
      folder = "Daily",
      date_format = "%Y-%m-%d",
      template = 'daily'
    },
    note_id_func = function(title)
      return title
    end,
    note_frontmatter_func = function(note)
      local out = { tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
    workspaces = {
      {
        name = "work",
        path = "~/Documents/Grafana notes",
      },
    },
  },
}

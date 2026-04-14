return {
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      opts = {
        enable_close = false,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
    config = function(_, opts)
      require('nvim-ts-autotag').setup(opts)

      local internal = require('nvim-ts-autotag.internal')
      local rename_tag = internal.rename_tag

      internal.rename_tag = function()
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok or not parser then
          return
        end

        return rename_tag()
      end
    end,
  },
}

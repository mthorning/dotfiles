return {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  config = function()
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
        lualine_x = { 'fileformat', 'filetype', 'buffer' },
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
  end
}

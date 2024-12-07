return {
  'goolord/alpha-nvim',
  enabled = false,
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local startify = require 'alpha.themes.startify'

    startify.file_icons.provider = "devicons"
    startify.section.top_buttons.val = {
      startify.button('e', 'New', ':enew <CR>', {})
    }

    require 'alpha'.setup(startify.opts)
  end
}

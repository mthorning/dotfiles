return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local startify = require 'alpha.themes.startify'

    startify.nvim_web_devicons.enabled = true
    startify.section.top_buttons.val = {
      startify.button('e', 'New', ':enew <CR>', {})
    }

    require 'alpha'.setup(startify.opts)
  end
}

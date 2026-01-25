return {
  "Shatur/neovim-ayu",
  priority = 1000,
  dependencies = {
    "cormacrelf/dark-notify",
  },
  config = function()
    -- Configure dark-notify to handle theme switching
    require('dark_notify').run({
      schemes = {
        dark = {
          colorscheme = "ayu",
          background = "dark",
        },
        light = {
          colorscheme = "ayu", 
          background = "light",
        }
      },
      onchange = function(mode)
        -- Configure ayu based on mode
        local is_dark = mode == "dark"
        require('ayu').setup({
          mirage = is_dark,
          terminal = false,
        })
        require('ayu').colorscheme()
      end,
    })
  end
}

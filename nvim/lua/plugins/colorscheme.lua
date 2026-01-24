return {
  "Shatur/neovim-ayu",
  priority = 1000,
  config = function()
    -- Detect macOS appearance mode
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    
    -- Use mirage for dark mode, light for light mode (matching Ghostty)
    local is_dark = result:match("Dark")
    
    require('ayu').setup({
      mirage = is_dark and true or false,
      terminal = false,
    })
    require('ayu').colorscheme()
  end
}

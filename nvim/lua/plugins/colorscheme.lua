return {
  "Shatur/neovim-ayu",
  priority = 1000,
  config = function()
    local current_appearance = nil

    local function apply_theme()
      -- Detect macOS appearance mode
      local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
      local result = handle:read("*a")
      handle:close()

      -- Use mirage for dark mode, light for light mode (matching Ghostty)
      local is_dark = result:match("Dark")
      local appearance = is_dark and 'dark' or 'light'

      -- Only reapply if appearance actually changed
      if appearance ~= current_appearance then
        current_appearance = appearance

        -- Set background first
        vim.o.background = appearance

        require('ayu').setup({
          mirage = is_dark and true or false,
          terminal = false,
        })
        require('ayu').colorscheme()
      end
    end

    -- Initial setup
    apply_theme()

    -- Check for appearance changes every 3 seconds
    local timer = vim.loop.new_timer()
    timer:start(0, 3000, vim.schedule_wrap(apply_theme))
  end
}

local startify = require'alpha.themes.startify'
startify.nvim_web_devicons.enabled = true
startify.section.top_buttons.val = {
    startify.button("t", "🖳 Terminal", ":call NeomuxTerm()<CR>"),
    startify.button("s", "🖫 Load Session", ":Telescope sessions<CR>"),
    startify.button("e", "🗋 New", ":enew <CR>")
}

require'alpha'.setup(startify.opts)

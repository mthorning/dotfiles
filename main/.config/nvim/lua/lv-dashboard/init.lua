
vim.g.dashboard_custom_header = O.dashboard.custom_header

vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {description = {'  Recent Files       '}, command = 'Telescope oldfiles'},
    b = {description = {'  Find File          '}, command = 'Telescope find_files'},
    c = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
    d = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    e = {description = {'  New                '}, command = ':enew'},
    f = {description = {'  Settings           '}, command = ':e ~/.config/nvim/lv-settings.lua'},
}

vim.g.dashboard_custom_footer = O.dashboard.footer

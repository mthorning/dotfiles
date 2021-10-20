
vim.g.dashboard_custom_header = O.dashboard.custom_header

vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {description = {'🖵  Terminal           '}, command = ':call NeomuxTerm()'},
    b = {description = {'  Recent Files       '}, command = 'Telescope oldfiles'},
    c = {description = {'  Find File          '}, command = 'Telescope find_files'},
    d = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
    e = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    f = {description = {'  New                '}, command = ':enew'},
}

vim.g.dashboard_custom_footer = O.dashboard.footer

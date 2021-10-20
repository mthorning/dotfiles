require'lualine'.setup {
    options = {
        theme = 'tokyonight',
    },
    sections = {
        lualine_z = { function() return vim.api.nvim_exec([[echo "| W: " . WindowNumber() . " |"]], true) end }
    },
    inactive_sections = {
        lualine_z = { function() return vim.api.nvim_exec([[echo "| W: " . WindowNumber() . " |"]], true) end }
    }
}

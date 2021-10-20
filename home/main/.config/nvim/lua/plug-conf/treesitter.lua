require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    indent = {enable = true},
    autotag = {enable = true},
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner"
            }
        }
    }
}

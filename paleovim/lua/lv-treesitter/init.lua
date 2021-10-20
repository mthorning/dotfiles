require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = {"haskell"},
    highlight= { enable = true },
    rainbow = { enable = true },
    indent = {enable = true},
    autotag = {enable = true},
}

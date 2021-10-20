local wk = require"which-key"
wk.setup {
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it"s label
        group = "+" -- symbol prepended to a group
    },
        window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local mappings = {
    e = {":NvimTreeToggle<CR>", "Explorer"},
    w = {":w<CR>", "Save"},
    a = {":wa<CR>", "Save All"},
    q = {":q<CR>", "Quit"},
    T = {":tabnew<CR>", "New Tab"},
    [";"] = {"<cmd>Alpha<CR>", "Dashboard"},
    t = {
        name = "+Terminal",
        t = {":tabnew | :call NeomuxTerm()<CR>", "Tab"},
        ["."] = "Here",
        s = "Split",
        v = "Vert split",
        f = {"<cmd>Lspsaga open_floaterm<CR>", "Float"},
        x = {"<cmd>Lspsaga close_floaterm<CR>", "Float"},
   },
    g = {":LazyGit<CR>", "Git"},
    f = {
        name = "+Find",
        f = {"<cmd>Telescope find_files<CR>", "File"},
        b = {"<cmd>Telescope buffers<CR>", "Buffer"},
        r = {"<cmd>Telescope oldfiles<CR>", "Recent"},
        t = {"<cmd>Telescope live_grep<CR>", "Text"},
        l = {"<cmd>Telescope loclist<CR>", "Loclist"},
        q = {"<cmd>Telescope quickfix<CR>", "QuickFix"},
        m = {"<cmd>Telescope marks<CR>", "Marks"},
        s = {"<cmd>Telescope search_history<CR>", "Search History"},
        c = {"<cmd>Telescope command_history<CR>", "Command History"},
        h = {"<cmd>Telescope help_tags<CR>", "Help"},
   },
    x = {":source $HOME/.config/nvim/init.lua<CR>", "Source Config"},
    S = {name = "+Session", s = {"<cmd>SaveSession<CR>", "Save Session"}, l = {"<cmd>Telescope sessions<CR>", "Load Session"}},
    l = {
        name = "+LSP",
        L = {"<cmd>lua vim.diagnostic.setloclist()<CR>", "To Loclist"},
        f = {"<cmd>Lspsaga lsp_finder<CR>", "Finder"},
        a = {"<cmd>Lspsaga code_action<CR>", "Action"},
        l = {"<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostic"},
        d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
        h = {"<cmd>Lspsaga hover_doc<CR>", "Hover"},
        p = {"<cmd>Lspsaga preview_definition<CR>", "Preview Definition"},
        r = {"<cmd>Lspsaga rename<CR>", "Rename"},
        F = {"<cmd>lua vim.lsp.buf.formatting()<CR>", "Format"},
        ["/"] = {"<cmd>LspInfo<CR>", "Info"},
        ["?"] = {"<cmd>LspInstallInfo<CR>", "Server Info"},
    }
};

wk.register(mappings, opts)

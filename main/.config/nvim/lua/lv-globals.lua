O = {
    auto_close_tree = 0,
    auto_complete = true,
    colorscheme = 'dracula',
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = 'bash',
	timeoutlen = 100,

    -- @usage pass a table with your desired languages
    treesitter = {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enabled = true},
        rainbow = {enabled = true},
    },

    database = {save_location = '~/.config/nvcode_db', auto_execute = 1},
    python = {
        linter = '',
        -- @usage can be 'yapf', 'black'
        formatter = '',
        autoformat = false,
        isort = false,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true},
		analysis = {type_checking = "basic", auto_search_paths = true, use_library_code_types = true}
    },
    dart = {sdk_path = '/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot'},
    lua = {
        -- @usage can be 'lua-format'
        formatter = '',
        autoformat = true,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    sh = {
        -- @usage can be 'shellcheck'
        linter = '',
        -- @usage can be 'shfmt'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    tsserver = {
        -- @usage can be 'eslint'
        linter = '',
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    json = {
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = true,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    go = {
      autoformat = true
    },
    tailwindls = {filetypes = {'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}},
    clang = {diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}},
	ruby = {
		diagnostics = {virtualtext = {spacing = 0, prefix = ""}, signs = true, underline = true},
		filetypes = {'rb', 'erb', 'rakefile'}
	},
    -- css = {formatter = '', autoformat = false, virtual_text = true},
    -- json = {formatter = '', autoformat = false, virtual_text = true}

	dashboard = {
		custom_header = {
"  `--..__   `--.__   `--._ `-._`-.`_=_'.-'_.-' _.--'   __.--'   __..--' ",
"--..__   `--..__  `--.__  `--._`-q(-_-)p-'_.--'  __.--'  __..--'   __..-- ",
"      ``--..__  `--..__ `--.__ `-'_) (_`-' __.--' __..--'  __..--'' ",
"...___        ``--..__ `--..__`--/__/  \\--'__..--' __..--''        ___... ",
"      ```---...___    ``--..__`_(<_   _/)_'__..--''    ___...---''' ",
"```-----....._____```---...___(__\\_\\_|_/__)___...---'''_____.....-------- ",
"____   __  ________   _______   _       _   _______   ____   __   _______ ",
"|| \\\\  ||  ||______  ||     ||  \\\\     //  ||_____||  || \\\\  ||  ||_____|| ",
"||  \\\\_||  ||______  ||_____||   \\\\___//   ||     ||  ||  \\\\_||  ||     ||"
		},
		footer= {''}
	}
}

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')


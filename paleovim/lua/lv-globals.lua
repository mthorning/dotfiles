O = {
    auto_close_tree = 1,
    auto_complete = true,
    colorscheme = 'dracula',
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = 'bash',
    timeoutlen = 100,
    database = {save_location = '~/.config/nvcode_db', auto_execute = 1},
    python = {
        linter = '',
        formatter = 'yapf',
        autoformat = true,
        isort = true,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true},
	analysis = {type_checking = "basic", auto_search_paths = true, use_library_code_types = true}
    },
    dart = {sdk_path = '/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot'},
    lua = {
        formatter = 'lua-format',
        autoformat = false,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    sh = {
        linter = '',
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    tsserver = {
        linter = 'eslint',
        formatter = 'prettier',
        autoformat = true,
        diagnostics = {virtual_text = {spacing = 0, prefix = ""}, signs = true, underline = true}
    },
    json = {
        formatter = 'prettier',
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


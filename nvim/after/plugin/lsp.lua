-- vim:foldmethod=marker
-- init {{{
local lspconfig = require('lspconfig')
local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"
local root_pattern = lspconfig.util.root_pattern

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = false})
-- }}}

-- efm {{{
local eslint = {
    lintCommand = 'eslint -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'},
    formatCommand = 'eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    formatStdin = true
}

local prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true
}

local luaformatter = {formatCommand = 'lua-format -i', formatStdin = true}

lspconfig.efm.setup {
    cmd = {lsp_servers .. "/efm/efm-langserver"},
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        vim.cmd [[augroup lsp_formatting]]
        vim.cmd [[autocmd!]]
        vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync({}, 1000)]]
        vim.cmd [[augroup END]]
    end,
    init_options = {
        documentFormatting = true,
        codeAction = true,
        document_formatting = true
    },
    root_dir = root_pattern({'.git/'}),

    filetypes = {
        "lua", "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescript.tsx", "typescriptreact", "less", "scss", "css"
    },
    settings = {
        log_level = 1,
        log_file = '~/efm.log',
        rootMarkers = {".git/"},
        languages = {
            less = {prettier},
            css = {prettier},
            html = {prettier},
            javascript = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            json = {prettier},
            lua = {luaformatter},
            markdown = {prettier},
            scss = {prettier},
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            yaml = {prettier},
            ["javascript.jsx"] = {prettier, eslint},
            ["typescript.tsx"] = {prettier, eslint}
        }
    }
}
-- }}}

-- tsserver {{{
lspconfig.tsserver.setup {
    init_options = {
      preferences = {
        disableSuggestions = true,
        includeCompletionsForModuleExports = false,
      }
    },
    cmd = {
        lsp_servers .. "/tsserver/node_modules/.bin/typescript-language-server",
        "--stdio"
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        require'illuminate'.on_attach(client)
    end
}
-- }}}

-- sumneko_lua {{{
local sumneko_root_path = lsp_servers .. '/sumneko_lua/extension/server/'
local sumneko_binary = sumneko_root_path .. "bin/" .. "/lua-language-server"

local runtime_path = vim.split(package.path, ';')

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    on_attach = function(client)
        require'illuminate'.on_attach(client)
        client.resolved_capabilities.document_formatting = false
    end,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false}
        }
    }
}
-- }}}

-- jsonls {{{
require'lspconfig'.jsonls.setup {
    cmd = {
        lsp_servers .. "/jsonls/node_modules/.bin/vscode-json-language-server"
    }
}
-- }}}

-- yamlls {{{
require'lspconfig'.yamlls.setup {
    cmd = {
        lsp_servers .. "/yaml/node_modules/.bin/yaml-language-server", "--stdio"
    }
}

-- }}}

-- vimls {{{
require'lspconfig'.vimls.setup {
    cmd = {
        lsp_servers .. "/vim/node_modules/.bin/vim-language-server", "--stdio"
    }
}
-- }}}

-- html {{{
require'lspconfig'.html.setup {
    cmd = {
        lsp_servers ..
            "/vscode-langservers-extracted/node_modules/.bin/vscode-html-language-server",
        "--stdio"
    }
}
-- }}}

-- cssls {{{
require'lspconfig'.cssls.setup {
    cmd = {
        lsp_servers .. "/cssls/node_modules/.bin/vscode-css-language-server",
        "--stdio"
    }
}
-- }}}

-- gopls {{{
require'lspconfig'.gopls.setup {
    cmd = {lsp_servers .. "/go/gopls"},
    root_dir = root_pattern("go.mod", ".git")
}
-- }}}

-- phpactor {{{
require'lspconfig'.phpactor.setup {
    cmd = {lsp_servers .. "/phpactor-source/bin/phpactor", "language-server"},
    root_dir = root_pattern(".git"),
    filetypes = {"php"}
}
-- }}}

-- rust_analyzer {{{
local rt = require("rust-tools")

require('rust-tools').setup {
    server = {
      cmd = {lsp_servers .. "/rust/rust-analyzer"},
      on_attach = function(_, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<Leader>lh", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- Code action groups
        vim.keymap.set("n", "<Leader>la", rt.code_action_group.code_action_group, { buffer = bufnr })
      end,
    },
    hover_actions = {
      auto_focus = true
    },
    dap = {
      adapter = {
        type = "executable",
        command = "lldb-vscode",
        name = "rt_lldb",
      },
    },
}
-- }}}

-- svelte {{{
require'lspconfig'.svelte.setup {
    cmd = {lsp_servers .. "/svelte/node_modules/.bin/svelteserver", "--stdio"}
}
-- }}}

-- pyright {{{
require'lspconfig'.pyright.setup {
    cmd = {
        lsp_servers .. "/python/node_modules/.bin/pyright-langserver", "--stdio"
    }
}
-- }}}
-- Remember to update LspInstallAll function with new servers.

local lspsaga = require 'lspsaga'
lspsaga.setup { -- defaults ...
    debug = false,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = 'X',
    warn_sign = '⚠',
    hint_sign = '?',
    infor_sign = 'ℹ',
    diagnostic_header_icon = ' ',
    -- code action title icon
    code_action_icon = ' ',
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = false
    },
    finder_definition_icon = ' ',
    finder_reference_icon = ' ',
    max_preview_lines = 10,
    finder_action_keys = {
        open = 'o',
        vsplit = 'v',
        split = 's',
        quit = 'q',
        scroll_down = '<C-f>',
        scroll_up = '<C-b>'
    },
    code_action_keys = {quit = 'q', exec = '<CR>'},
    rename_action_keys = {quit = '<C-c>', exec = '<CR>'},
    definition_preview_icon = '  ',
    border_style = 'single',
    rename_prompt_prefix = '➤',
    server_filetype_map = {}
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    indent = {enable = true},
    ignore_install = {"phpdoc", "c", "haskell"},
    autotag = {enable = true},
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner'
            }
        }
    }
}

require'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class', 'function', 'method', 'for', 'while', 'if', 'switch',
            'case'
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {'chapter', 'section', 'subsection', 'subsubsection'},
        rust = {'impl_item', 'struct', 'enum'},
        scala = {'object_definition'},
        vhdl = {'process_statement', 'architecture_body', 'entity_declaration'},
        markdown = {'section'},
        elixir = {
            'anonymous_function', 'arguments', 'block', 'do_block', 'list',
            'map', 'tuple', 'quoted_content'
        },
        json = {'pair'},
        yaml = {'block_mapping_pair'}
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil
}

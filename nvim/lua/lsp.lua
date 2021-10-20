-- vim:foldmethod=marker

local lspconfig = require('lspconfig')
local lsp_servers = vim.fn.stdpath('data') .. "/lsp_servers"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = false})

-- EFM {{{
local eslint = {
    lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'},
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
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
        vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync({}, 1500)]]
        vim.cmd [[augroup END]]
    end,
    init_options = {
        documenFormatting = true,
        codeAction = true,
        document_formatting = true
    },
    root_dir = lspconfig.util.root_pattern({'.git/', '.'}),

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
--}}}

-- TSSERVER {{{
lspconfig.tsserver.setup {
    cmd = {
        lsp_servers .. "/tsserver/node_modules/.bin/typescript-language-server",
        "--stdio"
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
    end
}
--}}}

-- SUMNEKO_LUA {{{
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

local sumneko_root_path = lsp_servers .. '/sumneko_lua/extension/server/'
local sumneko_binary = sumneko_root_path .. "bin/" .. system_name ..
                           "/lua-language-server"

local runtime_path = vim.split(package.path, ';')

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false}
        }
    }
}
--}}} 

-- JSON {{{
require'lspconfig'.jsonls.setup {
    cmd = { lsp_servers .. "/vscode-langservers-extracted/node_modules/.bin/vscode-json-language-server", "--stdio" },
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
--}}}

-- YAML {{{
require'lspconfig'.yamlls.setup{
  cmd = { lsp_servers .. "/yaml/node_modules/.bin/yaml-language-server", "--stdio" }
}
--}}}

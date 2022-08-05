vim.api.nvim_create_user_command("LspInstallAll", function()
    local servers = {
        'sumneko_lua', 'efm', 'tsserver', 'jsonls', 'yamlls', 'vimls', 'cssls',
        'html', 'gopls', 'rust_analyzer', 'phpactor', 'pyright'
    }

    for _, server in pairs(servers) do vim.cmd(':LspInstall ' .. server) end
end, {})


fun! LspInstallAll()
lua << EOF 
  local servers = {
    'sumneko_lua',
    'efm',
    'tsserver',
    'jsonls',
    'yamlls',
    'vimls',
    'cssls',
    'html',
    'gopls',
    'rust_analyzer',
    'phpactor',
    'pyright',
  }
  for _, server in pairs(servers) do
    vim.cmd(':LspInstall '..server) 
  end
EOF 
endfun

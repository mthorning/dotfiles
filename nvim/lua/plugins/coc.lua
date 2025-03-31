return {
  'neoclide/coc.nvim',
  branch = 'release',
  event = 'VeryLazy',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'lua' },
  config = function()

    -- Set up coc extensions for typescript, eslint, snippets and prettier
    vim.g.coc_global_extensions = {
      'coc-tsserver',
      'coc-json',
      'coc-eslint',
      'coc-snippets',
      'coc-prettier',
      'coc-lua',
    }
    
    -- Configure Lua language server to recognize vim as a global
    vim.g.coc_user_config = vim.g.coc_user_config or {}
    vim.g.coc_user_config["Lua.diagnostics.globals"] = {"vim"}

    -- Enable COC's diagnostic float windows for Ctrl-n navigation
    vim.g.coc_enable_locationlist = 0
    vim.g.coc_diagnostic_disable_float = 0
    
    -- Make coc use same popup styling
    vim.g.coc_borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }

    -- Some servers have issues with backup files
    vim.opt.backup = false
    vim.opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms) leads to noticeable delays
    vim.opt.updatetime = 300

    -- Don't pass messages to |ins-completion-menu|
    vim.opt.shortmess:append('c')

    -- Setup completion: use tab for trigger completion
    local keyset = vim.keymap.set
    
    -- Use Tab for trigger completion with characters ahead and navigate
    function _G.check_back_space()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end
    
    local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
    
    -- Use <c-space> to select completion item
    keyset("i", "<c-space>", [[coc#pum#visible() ? coc#pum#confirm() : coc#refresh()]], opts)


    keyset("n", "<C-n>", '<cmd>call CocAction("diagnosticNext")<cr>')
    keyset("n", "<C-p>", '<cmd>call CocAction("diagnosticPrevious")<cr>')

  end
}

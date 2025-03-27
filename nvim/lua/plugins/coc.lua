return {
  'neoclide/coc.nvim',
  branch = 'release',
  event = 'VeryLazy',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  config = function()
    -- Disable diagnostics for typescript files in LSP to avoid duplicate messages
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      callback = function()
        -- Disable LSP diagnostics for these filetypes
        vim.diagnostic.disable(0)
      end
    })

    -- Set up coc extensions for typescript
    vim.g.coc_global_extensions = {
      'coc-tsserver',
      'coc-json',
    }

    -- Disable COC's diagnostic float windows (use your existing ones)
    vim.g.coc_enable_locationlist = 0
    vim.g.coc_diagnostic_disable_float = 1
    
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
    -- Use tab for trigger completion with characters ahead and navigate
    keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
    
    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
    
    -- Use <c-space> to trigger completion
    keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
  end
}
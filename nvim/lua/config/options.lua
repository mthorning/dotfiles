vim.opt.sw = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmode = false
vim.opt.mouse = 'a'
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.timeoutlen = 0
vim.opt.signcolumn = 'yes'
vim.opt.syntax = 'on'
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.clipboard = 'unnamedplus'
vim.g.rust_recommended_style = 0
vim.opt.laststatus = 3

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

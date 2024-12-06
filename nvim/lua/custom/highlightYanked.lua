vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlighOnYank", { clear = true}),
  callback = function()
    vim.highlight.on_yank { higroup='Visual', timeout=100 }
  end
})

vim.opt["tabstop"] = 4
vim.opt["softtabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.opt["expandtab"] = true

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = 'Run gofmt on save',
  group = vim.api.nvim_create_augroup('GoFormat', { clear = true }),
  buffer = 0,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, '\n')

    local output = vim.fn.system('gofmt', input)

    if vim.v.shell_error == 0 then
      local view = vim.fn.winsaveview()
      local formatted_lines = vim.split(output, '\n')
      if formatted_lines[#formatted_lines] == '' then
        table.remove(formatted_lines)
      end
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
      vim.fn.winrestview(view)
    end
  end
})

local state = {
  win = -1,
  buf = -1,
}

local set = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { noremap = true, silent = true, nowait = true, buffer = state.buf })
end

local function close()
  vim.api.nvim_win_close(state.win, false)
  state = {
    win = -1,
    buf = -1,
  }
end

local function rename()
  state.buf = vim.api.nvim_create_buf(false, true)

  if vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_create_autocmd('BufEnter', {
      buffer = state.buf,
      command = "startinsert"
    })

    set("<Enter>", function()
      local input = vim.api.nvim_buf_get_lines(state.buf, 0, 1, false)[1]
      if string.len(input) > 0 then
        vim.cmd("stopinsert")
        close()
        vim.lsp.buf.rename(input)
      end
    end)

    set("<Escape>", function()
      close()
    end)

    state.win = vim.api.nvim_open_win(state.buf, true,
      {
        relative = 'cursor',
        row = 1,
        col = -16,
        width = 32,
        height = 1,
        border = "rounded",
        style = "minimal",
        title = "New name"
      })
  end
end

vim.api.nvim_create_user_command('LspRename', rename, {})

local state = {
  win = -1,
  buf = -1
}

local set = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { silent = true, nowait = true, buffer = state.buf })
end

local function open_float()
  state.buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_create_autocmd('BufEnter', {
    buffer = state.buf,
    command = "startinsert"
  })

  vim.api.nvim_create_autocmd('TextChangedI', {
    callback = function(x, y)
      print(vim.inspect(x), vim.inspect(y))
    end
  })

  set("<Enter>", function()
  end)

  set("<Escape>", function()
    vim.api.nvim_win_close(state.win, false)
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
      title = "Rename"
    })
end

open_float()

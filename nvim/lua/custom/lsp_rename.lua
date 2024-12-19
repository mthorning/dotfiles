local M = {}

local hello
function M.rename()
  local co = coroutine.create(function(new_name)
    print(new_name)
    if new_name then
      vim.lsp.buf_rename(new_name)
    else
      Snacks.input({ prompt = "New name"}, function(input)
        coroutine.yield(input)
      end)
    end
  end)

  local _, input = coroutine.resume(co)
  coroutine.resume(co, input)

end

M.rename()

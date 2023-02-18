local AutoRemove = "AutoRemove"

local attach_to_buffer = function(output_bufnr, pattern, command)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup(AutoRemove, {clear = true}),
        pattern = pattern,
        callback = function()
            local append_data = function(_, data)
                if data then
                    vim.api
                        .nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end
            vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, {})
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_stdout = append_data,
                on_stderr = append_data
            })
        end
    })
end

local buf, win
vim.api.nvim_create_user_command("AutoRun", function()
    print("AutoRun starts now...")
    local pattern = vim.fn.input("Pattern eg. '*.rs': ")
    local command = vim.split(vim.fn.input("Command: eg. 'cargo run': "), " ")

    local current_win = vim.api.nvim_get_current_win()

    vim.cmd('vsplit')
    win = vim.api.nvim_get_current_win()
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_set_current_win(current_win)

    attach_to_buffer(tonumber(buf), pattern, command)

end, {})

vim.api.nvim_create_user_command("AutoRunStop", function()
    vim.api.nvim_del_augroup_by_name(AutoRemove)
    vim.api.nvim_buf_delete(buf, {force = true})
end, {})


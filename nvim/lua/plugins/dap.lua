-- vim:foldmethod=marker
--
return {
   'mfussenegger/nvim-dap',
  config = function()

  -- zig {{{
    -- see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode

    local dap = require('dap')
    dap.set_log_level('DEBUG')
    dap.adapters.lldb = {
      type = 'executable',
      command = '/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap', -- output of `xcrun -f lldb-dap`
      name = 'lldb',
      options = {
        initialize_timeout_sec = 10,
      }
    }

    dap.configurations.zig = {
      {
        name = 'Debug tests',
        type = 'lldb',
        request = 'launch',
        --[[ program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end, ]]
        program="${workspaceFolder}/zig-out/bin/test", -- will only work for a binary called "test" atm!
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }
    -- }}}

  end
}

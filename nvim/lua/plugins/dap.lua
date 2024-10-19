-- vim:foldmethod=marker
--
return {
   'mfussenegger/nvim-dap',
  config = function()

  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapBreakpointCondition', {text='❓', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapLogPoint', {text='💬', texthl='', linehl='', numhl=''})

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
        program = function()
          -- local file = vim.fn.input('Path to file: ', vim.fn.getcwd() .. '/', 'file')
          local file = vim.fn.expand('%')
          vim.fn.jobstart(
            'zig test --test-no-exec -femit-bin=zig-out/bin/debug >> ' .. file
          )
          return '${workspaceFolder}/zig-out/bin/debug'
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }
    -- }}}

  end
}

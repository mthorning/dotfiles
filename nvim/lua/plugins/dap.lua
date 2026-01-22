return {
  {
   'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  config = function()

  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapBreakpointCondition', {text='❓', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapLogPoint', {text='💬', texthl='', linehl='', numhl=''})

  local dap = require('dap')

    -- see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#vscode-js-debug-1

    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = {os.getenv('HOME') .. '/js-debug/src/dapDebugServer.js', '${port}'},
      }
    }

    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = "Launch file",
        runtimeExecutable = "deno",
        runtimeArgs = {
          "run",
          "--inspect-wait",
          "--allow-all"
        },
        program = "${file}",
        cwd = "${workspaceFolder}",
        attachSimplePort = 9229,
      },
    }

    -- see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode

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
          local file = vim.fn.expand('%')
          vim.system({
            'zig', 'test', '--test-no-exec', '-femit-bin=zig-out/bin/debug', file
          }):wait()
          return '${workspaceFolder}/zig-out/bin/debug'
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

    local dap_args = {}
    dap.configurations.rust = {
      {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
            local input = vim.fn.input('Path to executable and args (separated by --): ', vim.fn.getcwd() .. '/target/debug/', 'file')
            local program_path = input
            local args_str = ""
            local sep_idx = input:find(" -- ", 1, true)

            if sep_idx then
                program_path = input:sub(1, sep_idx - 1)
                args_str = input:sub(sep_idx + #(" -- "))
            end

            -- trim whitespace
            program_path = program_path:gsub("^%s+", ""):gsub("%s+$", "")

            if args_str ~= "" then
                dap_args = vim.split(args_str, ' ')
            else
                dap_args = {}
            end

            return program_path
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            return dap_args
        end,
      },
    }

      -- see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go
      dap.adapters.go = {
        type = 'executable';
        command = 'node';
        args = {os.getenv('HOME') .. '/vscode-go/extension/dist/debugAdapter.js'};
      }
      dap.configurations.go = {
        {
          type = 'go';
          name = 'Debug';
          request = 'launch';
          showLog = false;
          program = '${file}';
          dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
        },

        -- for running against Tilt dlv:
        {
          type = 'go';
          name = 'Attach to Dlv';
          request = 'attach';
          showLog = false;
          program = '${file}';
          mode = 'remote';
          trace = 'log';
          port = 2345;
          host = '127.0.0.1';
          debugAdapter = 'dlv-dap';
        },
     }

  end
},
  {
    "rcarriga/nvim-dap-ui",
    event = 'VeryLazy',
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require'dapui'.setup()
      local dap, dapui = require("dap"), require("dapui")

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
  end
  }
}

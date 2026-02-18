return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      local function command_exists(cmd)
        local handle = io.popen('which ' .. cmd .. ' 2>/dev/null')
        if handle then
          local result = handle:read('*a')
          handle:close()
          return result ~= ''
        end
        return false
      end

      local function get_fortune()
        if command_exists('fortune') and command_exists('cowsay') then
          local handle = io.popen('fortune -s | cowsay')
          if handle then
            local result = handle:read('*a')
            handle:close()
            return result
          end
        end

        return [[
   ╭─────────────────────────────╮
   │         Welcome back!       │
   ╰─────────────────────────────╯
        ]]
      end

      dashboard.section.header.val = vim.split(get_fortune(), '\n')

      dashboard.section.buttons.val = {
        dashboard.button('e', '  Explorer', '<cmd>Yazi<CR>'),
        dashboard.button('f', '  Find files', '<cmd>Telescope find_files<CR>'),
        dashboard.button('t', '  Text', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args({ prompt_title = "Text (C-a for args)" })<CR>'),
        dashboard.button('c', '  Conflicts', '<cmd>lua local cmd = vim.fn.executable("rg") == 1 and "rg --vimgrep \'<<<<<<<\' 2>/dev/null" or "git grep -n \'<<<<<<<\' 2>/dev/null"; local results = vim.fn.systemlist(cmd); if vim.v.shell_error ~= 0 or #results == 0 then vim.notify("No conflicts found", vim.log.levels.INFO); return end; vim.fn.setqflist({}, "r", { title = "Merge Conflicts", lines = results }); vim.cmd("copen"); vim.cmd("cfirst")<CR>'),
        dashboard.button('r', '  Recent files', '<cmd>Telescope oldfiles<CR>'),
        dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
      }

      dashboard.section.footer.val = os.date('%A')

      dashboard.config.layout = {
        { type = 'padding', val = 2 },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
        { type = 'padding', val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end
  }
}

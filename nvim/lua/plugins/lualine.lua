return {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  config = function()
    local function setup_lualine()
      local lualine = require('lualine')

      -- Ayu color palette (adapts based on light/dark mode)
      local colors = {}
      if vim.o.background == 'light' then
        colors = {
          bg       = '#f3f4f5',
          fg       = '#5c6166',
          yellow   = '#f29718',
          cyan     = '#55b4d4',
          darkblue = '#131721',
          green    = '#86b300',
          orange   = '#f07171',
          violet   = '#a37acc',
          magenta  = '#a37acc',
          blue     = '#399ee6',
          red      = '#f07171',
        }
      else
        colors = {
          bg       = '#212733',
          fg       = '#d9d7ce',
          yellow   = '#ffcc66',
          cyan     = '#5ccfe6',
          darkblue = '#0f1419',
          green    = '#bae67e',
          orange   = '#ffae57',
          violet   = '#dfbfff',
          magenta  = '#d4bfff',
          blue     = '#73d0ff',
          red      = '#f28779',
        }
      end

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand('%:p:h')
          local gitdir = vim.fn.finddir('.git', filepath .. ';')
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      -- Config
      local config = {
        options = {
          component_separators = '',
          section_separators = '',
          theme = {
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left {
        function()
          return string.upper(vim.fn.mode())
        end,
        color = function()
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      }

      ins_left {
        'filename',
        path = 1,
        shorting_target = 40,
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
      }

      ins_right {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = 'x', warn = '!', info = 'i' },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
      }

      ins_right {
        'diff',
        symbols = { added = '+', modified = '~', removed = '-' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }


      ins_right { 'location' }

      ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

      lualine.setup(config)
    end

    -- Initial setup
    setup_lualine()

    -- Reconfigure when colorscheme changes
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = setup_lualine
    })
  end
}

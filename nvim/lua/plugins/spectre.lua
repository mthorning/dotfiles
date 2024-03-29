return {
  'windwp/nvim-spectre',
  cmd = 'Spectre',
  opts = {
    color_devicons = true,
    open_cmd = 'vnew',
    live_update = false, -- auto excute search again when you write any file in vim
    line_sep_start = '┌-----------------------------------------',
    result_padding = '¦  ',
    line_sep = '└-----------------------------------------',
    is_insert_mode = true, -- start open panel on is_insert_mode
    highlight = { ui = "String", search = "DiffChange", replace = "DiffDelete" },
    mapping = {
      ['toggle_line'] = {
        map = "t",
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = "toggle current item"
      },
      ['enter_file'] = {
        map = "<cr>",
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = "goto current file"
      },
      ['send_to_qf'] = {
        map = "<C-q>",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all item to quickfix"
      },
      ['replace_cmd'] = {
        map = "r",
        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
        desc = "input replace vim command"
      },
      ['show_option_menu'] = {
        map = "?",
        cmd = "<cmd>lua require('spectre').show_options()<CR>",
        desc = "show option"
      },
      ['run_replace'] = {
        map = "R",
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = "replace all"
      },
      ['change_view_mode'] = {
        map = "v",
        cmd = "<cmd>lua require('spectre').change_view()<CR>",
        desc = "change result view mode"
      },
      ['toggle_live_update'] = {
        map = "u",
        cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
        desc = "update change when vim write file."
      },
      ['toggle_ignore_case'] = {
        map = "<C-i>",
        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
        desc = "toggle ignore case"
      },
      ['toggle_ignore_hidden'] = {
        map = "<C-h>",
        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
        desc = "toggle search hidden"
      }
      -- you can put your mapping here it only use normal mode
    }
  }
}

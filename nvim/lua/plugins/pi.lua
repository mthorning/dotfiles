return {
  dir = vim.fn.stdpath('config'),
  name = 'pi-tmux-local',
  cmd = {
    'PiChatSelection',
    'PiApplySelection',
    'PiNewPane',
  },
  config = function()
    require('pi_tmux').setup()
  end,
}

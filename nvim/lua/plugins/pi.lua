return {
  dir = vim.fn.stdpath('config'),
  name = 'pi-tmux-local',
  cmd = {
    'PiChatHere',
    'PiChatSelection',
    'PiApplySelection',
    'PiNewPane',
    'PiChatDiff',
    'PiChatDiffNew',
  },
  config = function()
    require('pi_tmux').setup()
  end,
}

return {
  'pablopunk/pi.nvim',
  cmd = {
    'PiAsk',
    'PiAskSelection',
    'PiCancel',
    'PiLog',
  },
  config = function()
    require('pi').setup()
  end,
}

require('session_manager').setup({
    sessions_dir = require 'plenary.path':new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
    path_replacer = '__', -- The character to which the path separator will be replaced for session files.
    colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
    autoload_last_session = false, -- Automatically load last session on startup is started without arguments.
    autosave_last_session = false, -- Automatically save last session on exit.
    autosave_ignore_paths = {'~'} -- Folders to ignore when autosaving a session.
})

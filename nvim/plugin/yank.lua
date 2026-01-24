local get_buffer_absolute = function()
  return vim.fn.expand '%:p'
end

local get_buffer_cwd_relative = function()
  return vim.fn.expand '%:.'
end

local get_visual_bounds = function()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then
    error('get_visual_bounds must be called in visual or visual-line mode (current mode: ' .. vim.inspect(mode) .. ')')
  end
  local is_visual_line_mode = mode == 'V'
  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'

  return {
    start_line = math.min(start_pos[2], end_pos[2]),
    end_line = math.max(start_pos[2], end_pos[2]),
    start_col = is_visual_line_mode and 0 or math.min(start_pos[3], end_pos[3]) - 1,
    end_col = is_visual_line_mode and -1 or math.max(start_pos[3], end_pos[3]),
    mode = mode,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

local format_line_range = function(start_line, end_line)
  return start_line == end_line and tostring(start_line) or start_line .. '-' .. end_line
end

local simulate_yank_highlight = function(bounds)
  local ns = vim.api.nvim_create_namespace 'simulate_yank_highlight'
  vim.highlight.range(0, ns, 'IncSearch', { bounds.start_line - 1, bounds.start_col }, { bounds.end_line - 1, bounds.end_col }, { priority = 200 })
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end, 150)
end

local exit_visual_mode = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

local yank_visual_with_path = function(path)
  local bounds = get_visual_bounds()

  local selected_lines = vim.fn.getregion(bounds.start_pos, bounds.end_pos, { type = bounds.mode })
  local selected_text = table.concat(selected_lines, '\n')

  local line_range = format_line_range(bounds.start_line, bounds.end_line)
  local path_with_lines = path .. ':' .. line_range

  local result = path_with_lines .. '\n\n' .. selected_text
  vim.fn.setreg('+', result)

  simulate_yank_highlight(bounds)

  exit_visual_mode()
end

local function yank_absolute()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    yank_visual_with_path(get_buffer_absolute())
  else
    local path = get_buffer_absolute()
    local line_num = vim.fn.line('.')
    local path_with_line = path .. ':' .. line_num
    vim.fn.setreg('+', path_with_line)
    vim.notify('Yanked: ' .. path_with_line)
  end
end

local function yank_relative()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    yank_visual_with_path(get_buffer_cwd_relative())
  else
    local path = get_buffer_cwd_relative()
    local line_num = vim.fn.line('.')
    local path_with_line = path .. ':' .. line_num
    vim.fn.setreg('+', path_with_line)
    vim.notify('Yanked: ' .. path_with_line)
  end
end

local get_severity_string = function(severity)
  local severity_map = {
    [vim.diagnostic.severity.ERROR] = 'ERROR',
    [vim.diagnostic.severity.WARN] = 'WARN',
    [vim.diagnostic.severity.INFO] = 'INFO',
    [vim.diagnostic.severity.HINT] = 'HINT',
  }
  return severity_map[severity] or 'UNKNOWN'
end

local yank_diagnostic_with_path = function(path)
  local line = vim.fn.line('.')
  local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
  
  if #diagnostics == 0 then
    vim.notify('No diagnostic at cursor position', vim.log.levels.WARN)
    return
  end
  
  local diagnostic = diagnostics[1]
  
  local start_line = diagnostic.lnum + 1
  local end_line = diagnostic.end_lnum and (diagnostic.end_lnum + 1) or start_line
  local line_range = format_line_range(start_line, end_line)
  
  local severity_str = get_severity_string(diagnostic.severity)
  local path_with_lines = path .. ':' .. line_range
  
  local result = path_with_lines .. '\n\n[' .. severity_str .. '] ' .. diagnostic.message
  vim.fn.setreg('+', result)
  
  vim.notify('Yanked diagnostic: ' .. path_with_lines)
end

local function yank_diagnostic_absolute()
  yank_diagnostic_with_path(get_buffer_absolute())
end

local function yank_diagnostic_relative()
  yank_diagnostic_with_path(get_buffer_cwd_relative())
end

vim.api.nvim_create_user_command('YankAbsolutePath', yank_absolute, {})
vim.api.nvim_create_user_command('YankRelativePath', yank_relative, {})
vim.api.nvim_create_user_command('YankDiagnosticAbsolute', yank_diagnostic_absolute, {})
vim.api.nvim_create_user_command('YankDiagnosticRelative', yank_diagnostic_relative, {})


local M = {}

local CHAT_SYSTEM_PROMPT = [[You are running inside a custom Neovim + tmux workflow. The user started this conversation from Neovim and will continue interacting with you in tmux. Use the provided file context to answer their request, and feel free to ask follow-up questions in the tmux conversation if needed.]]

local APPLY_SYSTEM_PROMPT = [[You are running inside a custom Neovim apply workflow. The user wants a direct edit based on the selected code. Make the requested change immediately by editing files as needed. Do not ask follow-up questions.]]

local JJ_DIFF_SYSTEM_PROMPT_TEMPLATE = [[You are reviewing a jj (Jujutsu) diff inside Neovim. The user has selected a portion of a diff and wants to discuss it.

You are seeing only the selected hunk(s), not the full diff. If you need more context:
- Run `jj diff %s` to see the full diff (same args the user used)
- Add a fileset to narrow: `jj diff %s <filename>`
- Run `jj diff %s -s` for a summary of all changed files

The diff is in unified diff format. Lines starting with + are additions, - are deletions.]]

local GENERIC_DIFF_SYSTEM_PROMPT = [[You are reviewing a unified diff between two files inside Neovim. The user may have selected part of the diff or placed the cursor inside a hunk.

You are seeing only the selected hunk(s), not necessarily the full diff. If you need more context, ask the user to open a larger selection or inspect the underlying files.

The diff is in unified diff format. Lines starting with + are additions, - are deletions.]]

local EMPTY_FILE_NOTE = [[NOTE: This file is currently empty. If the user asks for changes, create or populate it directly.]]

local function buffer_is_empty(bufnr)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count == 0 then
    return true
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match('%S') then
      return false
    end
  end

  return true
end

function M.buffer_is_file_backed(bufnr)
  if vim.bo[bufnr].buftype ~= '' then
    return false
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  return filename ~= nil and filename ~= ''
end

function M.get_visual_selection_range()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  if not start_pos or not end_pos then
    return nil
  end

  local start_line = start_pos[2]
  local end_line = end_pos[2]
  if start_line == 0 or end_line == 0 then
    return nil
  end
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  return { start = start_line, ['end'] = end_line }
end

function M.get_cursor_position()
  local pos = vim.api.nvim_win_get_cursor(0)
  return {
    line = pos[1],
    col = pos[2] + 1,
  }
end

function M.format_prompt_label(bufnr, selection_range, cursor_position)
  local components = {}
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename ~= '' then
    table.insert(components, vim.fn.fnamemodify(filename, ':t'))
  end
  if selection_range and selection_range.start and selection_range['end'] then
    table.insert(components, string.format('%d:%d', selection_range.start, selection_range['end']))
  elseif cursor_position and cursor_position.line and cursor_position.col then
    table.insert(components, string.format('%d:%d', cursor_position.line, cursor_position.col))
  end
  if #components == 0 then
    return 'ask pi: '
  end
  return string.format('ask pi (%s): ', table.concat(components, ':'))
end

local function filetype_for(bufnr)
  return vim.bo[bufnr].filetype ~= '' and vim.bo[bufnr].filetype or 'text'
end

local function limit_lines(lines, max_lines)
  if #lines <= max_lines then
    return vim.deepcopy(lines), false
  end
  return vim.list_slice(lines, 1, max_lines), true
end

local function truncate_to_bytes(text, max_bytes)
  if #text <= max_bytes then
    return text, false
  end
  return text:sub(1, max_bytes), true
end

local function content_block(label, text)
  return string.format('%s:\n```\n%s\n```', label, text)
end

function M.system_prompt_for(opts)
  opts = opts or {}
  if opts.mode == 'apply' then
    return APPLY_SYSTEM_PROMPT
  end
  if opts.mode == 'diff' then
    if opts.diff_kind == 'jj' then
      local args = opts.diff_args or ''
      return string.format(JJ_DIFF_SYSTEM_PROMPT_TEMPLATE, args, args, args)
    end
    return GENERIC_DIFF_SYSTEM_PROMPT
  end
  return CHAT_SYSTEM_PROMPT
end

function M.get_buffer_context(bufnr, config, opts)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local limited_lines, did_trim_lines = limit_lines(lines, config.max_context_lines)
  local content, did_trim_bytes = truncate_to_bytes(table.concat(limited_lines, '\n'), config.max_context_bytes)
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local parts = {
    string.format('File: %s', filename),
    string.format('Filetype: %s', filetype_for(bufnr)),
    content_block('File content', content),
  }

  if did_trim_lines or did_trim_bytes then
    parts[#parts + 1] = string.format(
      'NOTE: Context was trimmed for speed (max_lines=%d, max_bytes=%d).',
      config.max_context_lines,
      config.max_context_bytes
    )
  end

  if buffer_is_empty(bufnr) then
    parts[#parts + 1] = EMPTY_FILE_NOTE
  end

  return table.concat(parts, '\n\n')
end

function M.get_visual_context(bufnr, config, opts)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local selection_range = M.get_visual_selection_range() or { start = 1, ['end'] = #all_lines }
  local before = math.max(1, selection_range.start - config.selection_context_lines)
  local after = math.min(#all_lines, selection_range['end'] + config.selection_context_lines)

  local nearby_lines = vim.api.nvim_buf_get_lines(bufnr, before - 1, after, false)
  local selected_lines = vim.api.nvim_buf_get_lines(bufnr, selection_range.start - 1, selection_range['end'], false)
  local nearby_text, nearby_trimmed = truncate_to_bytes(table.concat(nearby_lines, '\n'), config.max_context_bytes)
  local selected_text, selected_trimmed = truncate_to_bytes(table.concat(selected_lines, '\n'), config.max_context_bytes)

  local parts = {
    string.format('File: %s', filename),
    string.format('Filetype: %s', filetype_for(bufnr)),
    string.format('Selected lines: %d-%d', selection_range.start, selection_range['end']),
    content_block('Selected content', selected_text),
    content_block(string.format('Nearby context (%d-%d)', before, after), nearby_text),
  }

  if nearby_trimmed or selected_trimmed then
    parts[#parts + 1] = string.format(
      'NOTE: Selection context was trimmed for speed (max_bytes=%d).',
      config.max_context_bytes
    )
  end

  if buffer_is_empty(bufnr) then
    parts[#parts + 1] = EMPTY_FILE_NOTE
  end

  return table.concat(parts, '\n\n')
end

function M.get_cursor_context(bufnr, config, opts)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cursor = M.get_cursor_position()
  local before = math.max(1, cursor.line - config.selection_context_lines)
  local after = math.min(#all_lines, cursor.line + config.selection_context_lines)

  local nearby_lines = vim.api.nvim_buf_get_lines(bufnr, before - 1, after, false)
  local current_line = all_lines[cursor.line] or ''
  local nearby_text, nearby_trimmed = truncate_to_bytes(table.concat(nearby_lines, '\n'), config.max_context_bytes)
  local current_line_text, current_line_trimmed = truncate_to_bytes(current_line, config.max_context_bytes)

  local parts = {
    string.format('File: %s', filename),
    string.format('Filetype: %s', filetype_for(bufnr)),
    string.format('Cursor: line %d, column %d', cursor.line, cursor.col),
    content_block(string.format('Current line (%d)', cursor.line), current_line_text),
    content_block(string.format('Nearby context (%d-%d)', before, after), nearby_text),
  }

  if nearby_trimmed or current_line_trimmed then
    parts[#parts + 1] = string.format(
      'NOTE: Cursor context was trimmed for speed (max_bytes=%d).',
      config.max_context_bytes
    )
  end

  if buffer_is_empty(bufnr) then
    parts[#parts + 1] = EMPTY_FILE_NOTE
  end

  return table.concat(parts, '\n\n')
end

--- Parse diff headers walking backward from a given line.
--- Returns the file path from the nearest `diff --git` header
--- and the hunk line number from the nearest `@@ ... @@` header.
local function find_diff_headers_backward(lines, from_line)
  local file_path = nil
  local hunk_start_line = nil
  for i = from_line, 1, -1 do
    local line = lines[i]
    if not hunk_start_line then
      local new_start = line:match('^@@ %-%d+[,%d]* %+(%d+)')
      if new_start then
        hunk_start_line = tonumber(new_start)
      end
    end
    if not file_path then
      local path = line:match('^diff %-%-git a/.+ b/(.+)$')
      if path then
        file_path = path
        break  -- file header is always above hunk headers, so we're done
      end
    end
  end
  return file_path, hunk_start_line
end

--- Find the end of the current hunk (next hunk header, next diff header, or end of buffer).
local function find_hunk_end(lines, from_line)
  for i = from_line + 1, #lines do
    local line = lines[i]
    if line:match('^@@ ') or line:match('^diff %-%-git ') then
      return i - 1
    end
  end
  return #lines
end

--- Find the start of the current hunk (the @@ line above cursor).
local function find_hunk_start(lines, from_line)
  for i = from_line, 1, -1 do
    if lines[i]:match('^@@ ') then
      return i
    end
    -- If we hit a diff header without finding a hunk header, stop
    if lines[i]:match('^diff %-%-git ') then
      return i
    end
  end
  return 1
end

function M.get_diff_context(bufnr, config, opts)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local diff_kind = vim.b[bufnr].diff_source_type or (bufname:match('^jj://') and 'jj' or 'generic')
  local diff_args = vim.b[bufnr].jj_diff_args or ''

  local range = M.get_visual_selection_range()

  local context_start, context_end
  if range then
    -- Visual selection mode: use selected lines
    context_start = range.start
    context_end = range['end']
  else
    -- Cursor mode: extract the full hunk around the cursor
    local cursor = M.get_cursor_position()
    context_start = find_hunk_start(lines, cursor.line)
    context_end = find_hunk_end(lines, cursor.line)
  end

  -- Collect context lines
  local context_lines = {}
  for i = context_start, math.min(context_end, #lines) do
    context_lines[#context_lines + 1] = lines[i]
  end
  local context_text = table.concat(context_lines, '\n')
  context_text = truncate_to_bytes(context_text, config.max_context_bytes)

  -- Walk backward to find file path and hunk line number
  local file_path, hunk_line = find_diff_headers_backward(lines, context_start)

  -- Collect all file paths if selection spans multiple files
  local file_paths = {}
  if range then
    for i = math.max(1, context_start), math.min(context_end, #lines) do
      local path = lines[i] and lines[i]:match('^diff %-%-git a/.+ b/(.+)$')
      if path then
        file_paths[#file_paths + 1] = path
      end
    end
  end
  -- If we found a file path from walking backward and it's not already listed
  if file_path then
    local found = false
    for _, p in ipairs(file_paths) do
      if p == file_path then found = true; break end
    end
    if not found then
      table.insert(file_paths, 1, file_path)
    end
  end

  -- Build output
  local parts = {}
  if diff_kind == 'jj' then
    parts[#parts + 1] = string.format('Source: jj diff (args: %s)', diff_args ~= '' and diff_args or '(none)')
  else
    local file1 = vim.b[bufnr].diff_file1
    local file2 = vim.b[bufnr].diff_file2
    if file1 and file2 then
      parts[#parts + 1] = string.format('Source: file diff (%s ↔ %s)', file1, file2)
    else
      parts[#parts + 1] = 'Source: file diff'
    end
  end

  if #file_paths > 1 then
    parts[#parts + 1] = 'Files: ' .. table.concat(file_paths, ', ')
  elseif #file_paths == 1 then
    parts[#parts + 1] = string.format('File: %s', file_paths[1])
  end

  if hunk_line then
    parts[#parts + 1] = string.format('Hunk: line %d', hunk_line)
  end

  if range then
    parts[#parts + 1] = content_block(string.format('Selected diff (lines %d-%d)', context_start, context_end), context_text)
  else
    parts[#parts + 1] = content_block('Diff hunk', context_text)
  end

  -- Include diff-aware instructions so they work regardless of pane reuse
  parts[#parts + 1] = M.system_prompt_for({ mode = 'diff', diff_kind = diff_kind, diff_args = diff_args })

  return table.concat(parts, '\n\n')
end

function M.compose_message(message, built_context)
  return table.concat({
    message,
    '',
    built_context,
  }, '\n')
end

return M

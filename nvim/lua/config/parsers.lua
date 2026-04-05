-- nvim/lua/config/parsers.lua
-- Treesitter parser management module.
-- Used by nvim/scripts/install-parsers.lua (CLI) and
-- nvim/plugin/treesitter_commands.lua (:TSInstall / :TSUpdate).

local M = {}

-- ── Directories ───────────────────────────────────────────────────────────────

M.parser_dir = vim.fn.stdpath('data') .. '/site/parser'  -- on runtimepath
M.src_dir    = vim.fn.stdpath('data') .. '/parser-src'   -- grammar repo cache

M.queries_dir = vim.fn.stdpath('data') .. '/site/queries'  -- on runtimepath

-- ── Parser registry ───────────────────────────────────────────────────────────
-- url:        git remote
-- files:      source .c files relative to `location` (or repo root)
-- location:   subdirectory within the repo for source files (multi-grammar repos)
-- repo:       override clone dir name — use when two parsers share a repo
-- queries:    subdirectory within the repo for .scm files (default: 'queries')

M.parsers = {
  {
    lang     = 'javascript',
    url      = 'https://github.com/tree-sitter/tree-sitter-javascript',
    files    = { 'src/parser.c', 'src/scanner.c' },
  },
  {
    lang     = 'typescript',
    url      = 'https://github.com/tree-sitter/tree-sitter-typescript',
    files    = { 'src/parser.c', 'src/scanner.c' },
    location = 'typescript',
    repo     = 'tree-sitter-typescript',
    queries  = 'queries',  -- queries are at repo root, not inside typescript/
  },
  {
    lang     = 'tsx',
    url      = 'https://github.com/tree-sitter/tree-sitter-typescript',
    files    = { 'src/parser.c', 'src/scanner.c' },
    location = 'tsx',
    repo     = 'tree-sitter-typescript',
    queries  = 'queries',  -- same repo root queries used for both ts and tsx
  },
  {
    lang     = 'html',
    url      = 'https://github.com/tree-sitter/tree-sitter-html',
    files    = { 'src/parser.c', 'src/scanner.c' },
  },
  {
    lang     = 'css',
    url      = 'https://github.com/tree-sitter/tree-sitter-css',
    files    = { 'src/parser.c', 'src/scanner.c' },
  },
  {
    lang     = 'go',
    url      = 'https://github.com/tree-sitter/tree-sitter-go',
    files    = { 'src/parser.c' },
  },
  {
    lang     = 'rust',
    url      = 'https://github.com/tree-sitter/tree-sitter-rust',
    files    = { 'src/parser.c', 'src/scanner.c' },
  },
  {
    lang     = 'python',
    url      = 'https://github.com/tree-sitter/tree-sitter-python',
    files    = { 'src/parser.c', 'src/scanner.c' },
  },
  {
    lang     = 'json',
    url      = 'https://github.com/tree-sitter/tree-sitter-json',
    files    = { 'src/parser.c' },
  },
  -- lua, markdown, vimdoc, c are bundled with Neovim
}

-- Map of lang name → parser definition (for completion / lookup)
function M.parsers_by_lang()
  local t = {}
  for _, p in ipairs(M.parsers) do
    t[p.lang] = p
  end
  return t
end

-- ── Logging ───────────────────────────────────────────────────────────────────
-- log() adapts: CLI (`nvim -l`) uses io.write; inside Neovim uses vim.notify.

local function is_cli()
  return type(arg) == 'table' and arg[0] ~= nil
end

local function log(msg, level)
  if is_cli() then
    io.write(msg .. '\n')
    io.flush()
  else
    vim.notify(msg, level or vim.log.levels.INFO)
  end
end

local function log_err(msg)
  log(msg, vim.log.levels.ERROR)
end

-- ── Shell helpers ─────────────────────────────────────────────────────────────

local function sh(cmd)
  local out = vim.fn.system(cmd)
  return vim.v.shell_error == 0, out
end

-- ── Revision tracking ─────────────────────────────────────────────────────────

local function rev_path()
  return M.parser_dir .. '/revisions.json'
end

function M.load_revisions()
  local f = io.open(rev_path(), 'r')
  if not f then return {} end
  local data = f:read('*a')
  f:close()
  local ok, decoded = pcall(vim.json.decode, data)
  return ok and decoded or {}
end

function M.save_revisions(revs)
  local f = io.open(rev_path(), 'w')
  if f then
    f:write(vim.json.encode(revs))
    f:close()
  end
end

local function repo_head(repo_path)
  local ok, out = sh('git -C ' .. vim.fn.shellescape(repo_path) .. ' rev-parse HEAD')
  return ok and out:gsub('%s+', '') or nil
end

-- ── Fetch ─────────────────────────────────────────────────────────────────────

local function fetch_repo(p, fetched)
  local repo_name = p.repo or p.url:match('/([^/]+)$')
  local repo_path = M.src_dir .. '/' .. repo_name

  if fetched[repo_name] then
    return repo_path
  end
  fetched[repo_name] = true

  if vim.fn.isdirectory(repo_path) == 1 then
    log('  pulling ' .. repo_name .. ' …')
    local ok, out = sh(
      'git -C ' .. vim.fn.shellescape(repo_path) .. ' pull --ff-only --quiet 2>&1'
    )
    if not ok then
      log_err('git pull failed for ' .. repo_name .. ': ' .. out)
    end
  else
    log('  cloning ' .. repo_name .. ' …')
    local ok, out = sh(
      'git clone --depth=1 --quiet ' ..
      vim.fn.shellescape(p.url) .. ' ' ..
      vim.fn.shellescape(repo_path) .. ' 2>&1'
    )
    if not ok then
      log_err('git clone failed for ' .. repo_name .. ': ' .. out)
      return nil
    end
  end

  return repo_path
end

-- ── Compile ───────────────────────────────────────────────────────────────────

local function compile(p, repo_path)
  local base        = p.location and (repo_path .. '/' .. p.location) or repo_path
  local include_dir = base .. '/src'
  local output      = M.parser_dir .. '/' .. p.lang .. '.so'

  local sources = {}
  for _, f in ipairs(p.files) do
    local full = base .. '/' .. f
    if vim.fn.filereadable(full) == 1 then
      table.insert(sources, vim.fn.shellescape(full))
    end
  end

  if #sources == 0 then
    log_err(p.lang .. ': no source files found under ' .. base)
    return false
  end

  local cmd = table.concat({
    'cc',
    '-shared', '-fPIC', '-Os',
    '-I', vim.fn.shellescape(include_dir),
    table.concat(sources, ' '),
    '-o', vim.fn.shellescape(output),
  }, ' ')

  log('  compiling ' .. p.lang .. '.so …')
  local ok, out = sh(cmd)
  if not ok then
    log_err('compile failed for ' .. p.lang .. ':\n  ' .. out:gsub('\n', '\n  '))
    return false
  end

  return true
end

-- ── Copy queries ──────────────────────────────────────────────────────────────
local function copy_queries(p, repo_path)
  -- Source: {repo}/{p.queries}/ (default 'queries'), always at repo root
  local queries_subdir = p.queries or 'queries'
  local src  = repo_path .. '/' .. queries_subdir
  local dest = M.queries_dir .. '/' .. p.lang

  if vim.fn.isdirectory(src) == 0 then
    log_err(p.lang .. ': no queries directory found at ' .. src)
    return false
  end

  vim.fn.mkdir(dest, 'p')
  local ok, out = sh('cp -r ' .. vim.fn.shellescape(src) .. '/. ' .. vim.fn.shellescape(dest) .. '/')
  if not ok then
    log_err('failed to copy queries for ' .. p.lang .. ': ' .. out)
    return false
  end

  log('  queries copied')
  return true
end

-- ── Public API ────────────────────────────────────────────────────────────────

-- Install (or update) parsers.
-- langs:      list of language names; empty = all
-- opts.force: recompile even if revision matches
-- opts.quiet: suppress per-parser log lines
function M.install(langs, opts)
  opts = opts or {}
  local by_lang   = M.parsers_by_lang()
  local any_filter = #langs > 0

  -- Resolve which parsers to process
  local targets = {}
  if any_filter then
    for _, lang in ipairs(langs) do
      local p = by_lang[lang]
      if p then
        table.insert(targets, p)
      else
        log_err("Unknown parser: '" .. lang .. "'. Run :TSInstall with a known language.")
      end
    end
  else
    targets = M.parsers
  end

  vim.fn.mkdir(M.parser_dir, 'p')
  vim.fn.mkdir(M.queries_dir, 'p')
  vim.fn.mkdir(M.src_dir, 'p')

  local revisions             = M.load_revisions()
  local fetched               = {}  -- repos touched this call
  local n_installed, n_skipped, n_failed = 0, 0, 0

  for _, p in ipairs(targets) do
    if not opts.quiet then
      log('[' .. p.lang .. ']')
    end

    local repo_path = fetch_repo(p, fetched)
    if not repo_path then
      n_failed = n_failed + 1
      goto continue
    end

    local head       = repo_head(repo_path)
    local output     = M.parser_dir .. '/' .. p.lang .. '.so'
    local already_ok = (not opts.force)
      and head ~= nil
      and head == revisions[p.lang]
      and vim.fn.filereadable(output) == 1
      and vim.fn.isdirectory(M.queries_dir .. '/' .. p.lang) == 1

    if already_ok then
      log('  up to date (' .. head:sub(1, 8) .. ')')
      n_skipped = n_skipped + 1
      goto continue
    end

    if compile(p, repo_path) and copy_queries(p, repo_path) then
      revisions[p.lang] = head
      M.save_revisions(revisions)
      log('  ok' .. (head and (' (' .. head:sub(1, 8) .. ')') or ''))
      n_installed = n_installed + 1
    else
      n_failed = n_failed + 1
    end

    ::continue::
  end

  log(('installed=%d  skipped=%d  failed=%d'):format(n_installed, n_skipped, n_failed))
  return n_failed == 0
end

return M

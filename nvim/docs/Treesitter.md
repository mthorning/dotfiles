# Treesitter

Neovim 0.12 ships with a full built-in treesitter integration (`vim.treesitter`).
This config uses it directly — no `nvim-treesitter` plugin. Parsers are compiled
from source and managed by a small Lua module.

---

## How it works

### Parsers and queries

Treesitter needs two things per language:

- A **parser** — a compiled `.so` file that tokenises the language into a syntax tree
- **Queries** — `.scm` files that map tree nodes to highlight groups, folds, etc.

Neovim searches for parsers as `parser/{lang}.so` and queries as
`queries/{lang}/*.scm` anywhere on `runtimepath`. This config places them in:

```
~/.local/share/nvim/site/parser/    ← compiled parsers (.so)
~/.local/share/nvim/site/queries/   ← highlight queries (.scm)
```

Both directories are always on `runtimepath` — no further config needed.

`:TSInstall` handles both: it clones the grammar repo, compiles the parser, and
copies the bundled `.scm` files from the repo's `queries/` directory.

The following parsers are currently managed:

| Language | Notes |
|---|---|
| `javascript` | ships multiple query files: `highlights.scm`, `highlights-jsx.scm`, `highlights-params.scm`, `injections.scm` |
| `typescript` | compiled from `typescript/` subdir; queries from repo root |
| `tsx` | compiled from `tsx/` subdir; shares the same queries as typescript |
| `html` | |
| `css` | |
| `go` | no external scanner — single source file |
| `rust` | |
| `python` | |
| `json` | no external scanner |

> **Bundled with Neovim** (no installation needed): Lua, Markdown, Vimscript,
> Vimdoc, C.

### Highlighting

A `FileType` autocmd in `config/autocmd.lua` calls `vim.treesitter.start()` on
every buffer. If no parser exists for that filetype it silently no-ops.
`vim.treesitter.start()` automatically disables the legacy regex `:syntax`
engine for the buffer.

### Folding

Treesitter-aware folding is configured in `config/options.lua`:

```lua
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false  -- all folds open on load; toggle with zi
vim.opt.foldlevel  = 99
```

### Code context (winbar)

`nvim-navic` shows a breadcrumb trail in the winbar using LSP document symbols:

```
 MyClass   myMethod   if block
```

It uses LSP rather than treesitter, so it only activates on buffers where the
attached server reports `documentSymbolProvider` — tsgo, gopls, rust-analyzer,
pyright. Servers that don't support it (eslint) are silently skipped.

---

## Commands

### `:TSInstall [lang ...]`

Installs or updates one or more parsers. Clones the grammar repo if not present,
pulls if it is, compiles the `.so`, and copies the `.scm` query files.
Skips parsers whose output already matches the latest git HEAD.

```vim
:TSInstall javascript
:TSInstall typescript tsx go
:TSInstall                    " installs / updates all parsers
```

Tab-completion works for language names. Add `!` to force recompile even if
the revision is current:

```vim
:TSInstall! rust
```

Runs **synchronously** — takes a few seconds per parser.

### `:TSUpdate`

Pulls the latest sources for every parser and recompiles anything that has
changed. Runs **asynchronously** so the editor stays responsive; a notification
appears on completion.

```vim
:TSUpdate
```

---

## CLI usage

The same logic is available outside Neovim via `nvim -l`, useful for bootstrapping
a new machine before opening the editor properly:

```sh
# Install / update all parsers
nvim -l nvim/scripts/install-parsers.lua

# Force recompile everything
nvim -l nvim/scripts/install-parsers.lua update

# Specific languages only
nvim -l nvim/scripts/install-parsers.lua javascript tsx python
```

---

## Built-in bindings

These come from Neovim's treesitter integration with no plugin — active in any
buffer that has a parser loaded.

| Key | Mode | Description |
|---|---|---|
| `]n` | normal | Jump to next treesitter node |
| `[n` | normal | Jump to previous treesitter node |
| `an` | visual / operator | Select parent node |
| `in` | visual / operator | Select child node |

---

## New machine setup

1. Open Neovim — lazy.nvim auto-installs plugins (navic, nvim-ts-autotag) on first launch
2. Run `:TSInstall` to compile all parsers and copy their queries

**Requirements:**
- `git` — for cloning grammar repos
- `cc` — for compiling `.so` files (comes with Xcode Command Line Tools on macOS)

Both are standard on a dev Mac. If `cc` is missing the compile step will fail
with a clear error message.

---

## Adding a new parser

### 1. Find the grammar repo

Most official grammars live under the `tree-sitter` org:

```
https://github.com/tree-sitter/tree-sitter-{lang}
```

For languages not maintained there, check the
[tree-sitter-community](https://github.com/tree-sitter-community) org, or
search GitHub for `tree-sitter-{lang}`. The nvim-treesitter
[`parsers.lua`](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/lua/nvim-treesitter/parsers.lua)
is a useful reference for canonical repo URLs even if the plugin itself isn't used.

### 2. Add an entry to `nvim/lua/config/parsers.lua`

```lua
{
  lang  = 'mylang',
  url   = 'https://github.com/tree-sitter/tree-sitter-mylang',
  files = { 'src/parser.c', 'src/scanner.c' },
  -- omit scanner.c if the repo has no src/scanner.c
},
```

**Fields:**

| Field | Required | Description |
|---|---|---|
| `lang` | yes | Parser name — must match Neovim's filetype name for the language |
| `url` | yes | Git remote to clone |
| `files` | yes | Source `.c` files to compile, relative to `location` (or repo root) |
| `location` | no | Subdirectory within the repo where the source lives. Used when one repo contains multiple grammars (e.g. `typescript`, `tsx`) |
| `repo` | no | Override the clone directory name. Set this when two parser entries share the same repo so it is only cloned once |
| `queries` | no | Subdirectory within the repo containing `.scm` files. Defaults to `queries/`. Set explicitly when the queries live at the repo root but the source is in a subdirectory (e.g. typescript/tsx) |

### 3. Run `:TSInstall mylang`

The script copies every `.scm` file from the grammar's `queries/` directory
automatically. Most grammars ship their own `highlights.scm`.

### Shared-repo grammars (e.g. typescript / tsx)

When multiple parsers live in one repo, use `location` for the source subdir
and `repo` to share a single clone. If the queries are at the repo root rather
than inside the subdir, set `queries = 'queries'` explicitly:

```lua
{
  lang     = 'typescript',
  url      = 'https://github.com/tree-sitter/tree-sitter-typescript',
  files    = { 'src/parser.c', 'src/scanner.c' },
  location = 'typescript',          -- source is in typescript/src/
  repo     = 'tree-sitter-typescript',
  queries  = 'queries',             -- but queries are at repo root
},
{
  lang     = 'tsx',
  url      = 'https://github.com/tree-sitter/tree-sitter-typescript',
  files    = { 'src/parser.c', 'src/scanner.c' },
  location = 'tsx',
  repo     = 'tree-sitter-typescript',
  queries  = 'queries',
},
```

### Grammars that extend another language

Some parsers (TypeScript, TSX) only ship TS-specific query rules and rely on
inheriting the base language's queries (JavaScript) for keywords, operators,
literals etc. Without the inheritance, those tokens are uncoloured.

This is handled via thin override files in `nvim/queries/` (which is on
`runtimepath` and takes precedence over `site/queries/`). The `; extends`
modeline merges with the grammar's own queries rather than replacing them:

```scheme
; nvim/queries/typescript/highlights.scm
;; extends
;; inherits: javascript
```

If a new parser has poor highlighting for common syntax, check whether its
`highlights.scm` is missing an `inherits:` directive. Add an override file
under `nvim/queries/{lang}/highlights.scm` with the same two lines.

### Grammars with no bundled queries

A small number of grammar repos don't include `highlights.scm`. In that case
`:TSInstall` will log an error on the query-copy step. You have two options:

- Write your own `queries/{lang}/highlights.scm` in `~/.config/nvim/queries/`
  (files there take precedence over `site/queries/` on `runtimepath`)
- Use nvim-treesitter's query files as a reference — they are in
  `~/.local/share/nvim/lazy/nvim-treesitter/queries/` if the plugin was ever installed

---

## Debugging

### Unknown predicate errors

Some grammar repos ship query files that use predicates defined by nvim-treesitter
but not by Neovim's built-in engine (e.g. `is-not?`, `is?`). This produces a
decoration provider error on the affected buffer.

`nvim/plugin/treesitter_commands.lua` registers no-op handlers for the ones
encountered so far. If a new grammar causes this error, check which predicate
is unknown and add a handler:

```lua
-- is-not? defaults to true  (property never set without nvim-treesitter locals)
-- is?     defaults to false
vim.treesitter.query.add_predicate('unknown?', function() return true end, { force = true })
```

To see all currently registered predicates:

```vim
:lua print(vim.inspect(vim.treesitter.query.list_predicates()))
```

### `:Inspect`

Shows all highlight captures active under the cursor, including which group each
one resolves to. The most useful first step when highlighting looks wrong.

### `:InspectTree`

Opens a window showing the full parsed syntax tree for the current buffer.
Press `a` to toggle anonymous nodes, `o` to open the query editor.
Useful for writing or debugging query files.

### `:checkhealth vim.treesitter`

Reports the ABI version range Neovim supports and lists any parsers it can find
on `runtimepath`. Run this if a parser loads but highlighting still doesn't work
— an ABI mismatch will show up here.

### `:lua vim.treesitter.language.add('mylang')`

Returns `true` if the parser `.so` was found and loaded, or an error string if
not. Useful for confirming a parser is actually on `runtimepath` after
`:TSInstall`.

---

## File map

| File | Purpose |
|---|---|
| `nvim/lua/config/parsers.lua` | Parser registry and install/compile/query-copy module |
| `nvim/scripts/install-parsers.lua` | CLI wrapper (`nvim -l`) |
| `nvim/plugin/treesitter_commands.lua` | `:TSInstall` and `:TSUpdate` commands |
| `nvim/lua/plugins/navic.lua` | LSP breadcrumb winbar |
| `nvim/lua/plugins/treesitter.lua` | `nvim-ts-autotag` (HTML/JSX tag rename) |
| `nvim/lua/config/autocmd.lua` | `TreesitterHighlight` FileType autocmd |
| `nvim/lua/config/options.lua` | Fold options |
| `nvim/test/sample.{js,ts,go,py}` | Test files for verifying highlighting |

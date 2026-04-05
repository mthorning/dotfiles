-- nvim/plugin/treesitter_commands.lua
-- Defines :TSInstall and :TSUpdate without nvim-treesitter.
-- Also registers custom predicates used by grammar query files that
-- nvim-treesitter normally provides but Neovim's built-in engine does not.

-- ── Custom predicates ─────────────────────────────────────────────────────────
-- Some grammar repos ship highlights.scm files that use nvim-treesitter-specific
-- predicates. Without handlers registered, Neovim throws an error when it
-- encounters them. We register no-op handlers with the correct default values.
--
-- is?     checks if a metadata property IS set on the match (default: false)
-- is-not? checks if a metadata property is NOT set on the match (default: true)
--
-- Without nvim-treesitter's locals module, no properties are ever set, so
-- these defaults are semantically correct.

vim.treesitter.query.add_predicate('is?', function()
  return false
end, { force = true })

vim.treesitter.query.add_predicate('is-not?', function()
  return true
end, { force = true })

-- ── Parser management ─────────────────────────────────────────────────────────
local P = require('config.parsers')

-- List of known lang names for tab-completion
local function lang_names()
  return vim.tbl_map(function(p) return p.lang end, P.parsers)
end

-- ── :TSInstall [lang ...] ─────────────────────────────────────────────────────
-- Installs (or reinstalls with !) specific parsers.
-- With no args, installs all parsers that are missing or out of date.
-- Bang (!) forces recompile even if the revision is current.
--
-- Examples:
--   :TSInstall javascript typescript
--   :TSInstall! rust          ← force recompile

vim.api.nvim_create_user_command('TSInstall', function(opts)
  local langs = vim.split(opts.args, '%s+', { trimempty = true })
  P.install(langs, { force = opts.bang })
end, {
  nargs   = '*',
  bang    = true,
  desc    = 'Install treesitter parser(s)',
  complete = function(arglead, _, _)
    return vim.tbl_filter(
      function(l) return l:find(arglead, 1, true) == 1 end,
      lang_names()
    )
  end,
})

-- ── :TSUpdate ─────────────────────────────────────────────────────────────────
-- Pulls latest grammar sources and recompiles any that have changed.
-- Runs asynchronously so it doesn't block the editor.

vim.api.nvim_create_user_command('TSUpdate', function()
  vim.notify('TSUpdate: checking parsers…', vim.log.levels.INFO)
  local script = vim.fn.stdpath('config') .. '/scripts/install-parsers.lua'
  vim.system(
    { 'nvim', '-l', script, 'update' },
    { text = true },
    function(result)
      vim.schedule(function()
        if result.code == 0 then
          vim.notify('TSUpdate complete\n' .. result.stdout, vim.log.levels.INFO)
        else
          vim.notify(
            'TSUpdate failed:\n' .. result.stdout .. result.stderr,
            vim.log.levels.ERROR
          )
        end
      end)
    end
  )
end, {
  desc = 'Update all treesitter parsers (async)',
})

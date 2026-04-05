-- nvim/scripts/install-parsers.lua
-- CLI wrapper around nvim/lua/config/parsers.lua.
--
-- Usage (from repo root):
--   All parsers:      nvim -l nvim/scripts/install-parsers.lua
--   Force recompile:  nvim -l nvim/scripts/install-parsers.lua update
--   Specific langs:   nvim -l nvim/scripts/install-parsers.lua javascript tsx

local P = require('config.parsers')

local cli_args = type(arg) == 'table' and arg or {}
local force    = false
local langs    = {}

for i = 1, #cli_args do
  if cli_args[i] == 'update' then
    force = true
  else
    table.insert(langs, cli_args[i])
  end
end

io.write('Treesitter parser installer\n')
io.write('  parsers → ' .. P.parser_dir .. '\n')
io.write('  sources → ' .. P.src_dir .. '\n')
if force then io.write('  mode    → force recompile\n') end
io.write('\n')

P.install(langs, { force = force })

io.write('\nDone.\n')

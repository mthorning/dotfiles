-- Neovim 0.12 bug: treesitter highlighter decoration provider crashes
-- on telescope preview buffers (nil tree node in :range() call).
-- Re-register the provider with pcall-wrapped callbacks.
local ok, hl = pcall(require, 'vim.treesitter.highlighter')
if not ok or not hl then return end

local ns = vim.api.nvim_create_namespace('nvim.treesitter.highlighter')

local function wrap(fn)
  if not fn then return nil end
  return function(...)
    local success, result = pcall(fn, ...)
    if not success then return false end
    return result
  end
end

vim.api.nvim_set_decoration_provider(ns, {
  on_start = wrap(hl._on_start),
  on_win = wrap(hl._on_win),
  on_range = wrap(hl._on_range),
  _on_spell_nav = wrap(hl._on_spell_nav),
})

-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/mthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/mthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/mthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/mthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/mthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-tabnine"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/cmp-tabnine"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["far.vim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/far.vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["git-blame.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/git-blame.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  hop = {
    config = { "\27LJ\2\0021\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/hop"
  },
  ["impatient.nvim"] = {
    config = { "\27LJ\2\2)\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\14impatient\frequire\0" },
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["lazygit.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/lazygit.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  neomux = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/neomux"
  },
  ["neoscroll.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvcode-color-schemes.vim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvcode-color-schemes.vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-comment"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-comment"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-angry"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/vim-angry"
  },
  ["vim-localvimrc"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/vim-localvimrc"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "/home/mthorning/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: hop
time([[Config for hop]], true)
try_loadstring("\27LJ\2\0021\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bhop\frequire\0", "config", "hop")
time([[Config for hop]], false)
-- Config for: impatient.nvim
time([[Config for impatient.nvim]], true)
try_loadstring("\27LJ\2\2)\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\14impatient\frequire\0", "config", "impatient.nvim")
time([[Config for impatient.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

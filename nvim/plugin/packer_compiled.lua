-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = true
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
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/matthewthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/matthewthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/matthewthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/matthewthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/matthewthorning/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
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
  ["alpha-nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["git-blame.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/git-blame.nvim",
    url = "https://github.com/f-person/git-blame.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  kommentary = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lazygit.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/lazygit.nvim",
    url = "https://github.com/kdheepak/lazygit.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/tami5/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["neoscroll.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-spectre"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-spectre",
    url = "https://github.com/windwp/nvim-spectre"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim"
  },
  ["telescope-live-grep-raw.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/telescope-live-grep-raw.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-raw.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-illuminate"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/vim-illuminate",
    url = "https://github.com/RRethy/vim-illuminate"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n∫!\0\0\a\0É\1\0´\0016\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0005\5\a\0=\5\b\0045\5\t\0=\5\n\4=\4\v\0035\4\r\0005\5\f\0=\5\14\0045\5\15\0=\5\16\4=\4\17\0035\4\18\0=\4\19\3B\1\2\0015\1\20\0005\2\22\0005\3\21\0=\3\23\0025\3\24\0=\3\25\0025\3\26\0=\3\27\0025\3\28\0005\4\29\0=\4\30\0035\4\31\0=\4 \3=\3!\0025\3\"\0=\3#\0025\3$\0=\3%\0025\3&\0=\3'\0025\3(\0005\4)\0=\4*\0035\4+\0=\4,\0035\4-\0=\4 \0035\4.\0=\4/\3=\3,\0025\0030\0005\0041\0=\0042\0035\0043\0=\0044\0035\0045\0=\0046\0035\0047\0=\0048\3=\0032\0025\0039\0=\3:\0025\3;\0005\4<\0=\4=\0035\4>\0=\4?\0035\4@\0=\4\30\0035\4A\0=\4,\0035\4B\0=\4:\0035\4C\0=\4D\0035\4E\0=\4#\0035\4F\0=\4G\0035\4H\0=\4 \0035\4I\0=\0042\0035\4J\0=\4K\0035\4L\0=\0048\3=\3=\0025\3M\0=\3N\0025\3O\0005\4P\0=\4Q\0035\4R\0005\5S\0=\5\30\0045\5T\0=\5 \0045\5U\0=\5V\4=\4=\0035\4W\0=\4\27\0035\4X\0=\4D\0035\4Y\0=\4Z\0035\4[\0=\4,\0035\4\\\0=\4/\0035\4]\0=\4K\0035\4^\0=\0048\0035\4_\0=\4\30\0035\4`\0=\4a\0035\4b\0=\4c\0035\4d\0=\4e\3=\3D\0025\3f\0005\4g\0=\4\27\0035\4h\0=\4\23\0035\4i\0=\4j\0035\4k\0=\4l\0035\4m\0=\4n\0035\4o\0=\4p\3=\3K\0025\3q\0005\4r\0=\0042\0035\4s\0=\0044\0035\4t\0=\4u\0035\4v\0=\4w\0035\4x\0=\4?\0035\4y\0=\4z\0035\4{\0=\4G\0035\4|\0=\4\30\0035\4}\0=\4D\3=\3Z\0025\3~\0=\3G\0025\3\127\0=\3Ä\0025\3Å\0=\0038\0029\3Ç\0\18\5\2\0\18\6\1\0B\3\3\1K\0\1\0\rregister\1\3\0\0(:silent !tmux neww gh pr create<CR>\14Create PR\6j\1\3\0\0\30:silent !tmux neww ff<CR>\25Manage feature flags\1\3\0\0,:silent !tmux neww tmux-sessioniser<CR>\21New Tmux Session\1\3\0\0)<cmd>lua require\"dap\".run_last()<CR>\tLast\1\3\0\0*<cmd>lua require\"dap\".repl.open()<CR>\tREPL\1\3\0\0\\<cmd>lua require\"dap\".set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>\fMessage\6B\1\3\0\0U<cmd>lua require\"dap\".set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>\25Breakpoint condition\1\3\0\0002<cmd>lua require\"dap\".toggle_breakpoint()<CR>\22Toggle breakpoint\6O\1\3\0\0)<cmd>lua require\"dap\".step_out()<CR>\rStep out\6i\1\3\0\0*<cmd>lua require\"dap\".step_into()<CR>\14Step into\1\3\0\0*<cmd>lua require\"dap\".step_over()<CR>\14Step over\1\3\0\0)<cmd>lua require\"dap\".continue()<CR>\19Start/continue\1\0\1\tname\v+Debug\0064\1\3\0\0003<cmd>lua require(\"harpoon.ui\").nav_file(4)<CR>\15Nav Mark 4\0063\1\3\0\0003<cmd>lua require(\"harpoon.ui\").nav_file(3)<CR>\15Nav Mark 3\0062\1\3\0\0003<cmd>lua require(\"harpoon.ui\").nav_file(2)<CR>\15Nav Mark 2\0061\1\3\0\0003<cmd>lua require(\"harpoon.ui\").nav_file(1)<CR>\15Nav Mark 1\1\3\0\0;<cmd>lua require(\"harpoon.ui\").toggle_quick_menu()<CR>\15Show Marks\1\3\0\0004<cmd>lua require(\"harpoon.mark\").add_file()<CR>\rAdd Mark\1\0\1\tname\r+Harpoon\6?\1\3\0\0\28<cmd>LspInstallInfo<CR>\16Server Info\6/\1\3\0\0\21<cmd>LspInfo<CR>\tInfo\6F\1\3\0\0006<cmd>lua vim.lsp.buf.format({ async = true })<CR>\vFormat\1\3\0\0\28<cmd>Lspsaga rename<CR>\vRename\1\3\0\0(<cmd>Lspsaga preview_definition<CR>\23Preview Definition\1\3\0\0\31<cmd>Lspsaga hover_doc<CR>\nHover\1\3\0\0003<cmd>vsplit | lua vim.lsp.buf.definition()<CR>\29Goto Definition in split\1\3\0\0,<cmd>Telescope lsp_type_definitions<CR>\25Goto Type Definition\6d\1\3\0\0'<cmd>Telescope lsp_definitions<CR>\20Goto Definition\1\3\0\0+<cmd>Lspsaga show_line_diagnostics<CR>\20Line Diagnostic\1\3\0\0!<cmd>Lspsaga code_action<CR>\vAction\6S\1\3\0\0005<cmd>Telescope lsp_dynamic_workspace_symbols<CR>\17Find Symbols\1\3\0\0,<cmd>Telescope lsp_document_symbols<CR>\21List Doc Symbols\1\3\0\0&<cmd>Telescope lsp_references<CR>\15References\1\0\1\tname\n+Find\6L\1\3\0\0-<cmd>lua vim.diagnostic.setloclist()<CR>\15To Loclist\1\0\1\tname\t+LSP\6x\1\3\0\0\28:silent !chmod +x %<CR>\20Make Executable\1\3\0\0002<cmd>lua require(\"spectre\").open_visual()<CR>\fProject\6h\1\3\0\0!<cmd>Telescope help_tags<CR>\tHelp\1\3\0\0'<cmd>Telescope command_history<CR>\20Command History\1\3\0\0&<cmd>Telescope search_history<CR>\19Search History\6m\1\3\0\0\29<cmd>Telescope marks<CR>\nMarks\1\3\0\0 <cmd>Telescope quickfix<CR>\rQuickFix\6l\1\3\0\0\30<cmd>Telescope resume<CR>\15Last Query\1\3\0\0O<cmd>lua require(\"telescope\").extensions.live_grep_raw.live_grep_raw()<CR>\tGrep\1\3\0\0!<cmd>Telescope live_grep<CR>\tText\1\3\0\0 <cmd>Telescope oldfiles<CR>\vRecent\6b\1\3\0\0\31<cmd>Telescope buffers<CR>\vBuffer\6f\1\3\0\0\"<cmd>Telescope find_files<CR>\tFile\1\0\1\tname\n+Find\6g\1\3\0\0\17:LazyGit<CR>\bGit\6p\1\3\0\0\15:cprev<CR>\rPrevious\6n\1\3\0\0\15:cnext<CR>\tNext\6o\1\3\0\0\15:copen<CR>\tOpen\6c\1\3\0\0\16:cclose<CR>\nClose\1\0\1\tname\14+QuickFix\6v\1\3\0\0*:vsplit term://zsh | :startinsert<CR>\15Vert split\1\3\0\0):split term://zsh | :startinsert<CR>\21Horizontal split\6t\1\3\0\0002:tabnew | :edit term://zsh | :startinsert<CR>\bTab\6.\1\3\0\0\14:term<CR>\tHere\1\0\1\tname\14+Terminal\6;\1\3\0\0\19<cmd>Alpha<CR>\14Dashboard\6T\1\3\0\0\16:tabnew<CR>\fNew Tab\6q\1\3\0\0\v:q<CR>\tQuit\6A\6s\1\3\0\0\25<cmd>AutoRunStop<CR>\tStop\6r\1\3\0\0\21<cmd>AutoRun<CR>\bRun\1\0\1\tname\fAutoRun\6a\1\3\0\0\f:wa<CR>\rSave All\6w\1\3\0\0\v:w<CR>\tSave\6e\1\0\3\t<lt>\21which_key_ignore\f<s-tab>\21which_key_ignore\n<tab>\21which_key_ignore\1\3\0\0\24:NvimTreeToggle<CR>\rExplorer\1\0\5\vprefix\r<leader>\vsilent\2\vnowait\1\tmode\6n\fnoremap\2\vhidden\1\t\0\0\r<silent>\n<cmd>\n<Cmd>\t<CR>\tcall\blua\a^:\a^ \vlayout\nwidth\1\0\2\bmin\3\20\bmax\0032\vheight\1\0\1\fspacing\3\3\1\0\2\bmin\3\4\bmax\3\25\vwindow\fpadding\1\5\0\0\3\2\3\2\3\2\3\2\vmargin\1\5\0\0\3\1\3\0\3\1\3\0\1\0\2\rposition\vbottom\vborder\vsingle\nicons\1\0\0\1\0\3\ngroup\6+\14separator\b‚ûú\15breadcrumb\a¬ª\nsetup\14which-key\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/matthewthorning/.local/share/nvim/site/pack/packer/opt/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'which-key.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles(0) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

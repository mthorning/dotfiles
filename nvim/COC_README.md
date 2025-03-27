# COC Setup for TypeScript in Neovim

This setup uses COC.nvim for TypeScript-related features while maintaining the native LSP for other languages.

## Features

- TypeScript completion and error highlighting via COC
- Keeps all existing LSP-based keymaps in which_key working
- Only uses COC for specific filetypes (TypeScript/JavaScript)
- Disables COC diagnostic popups (uses your existing ones)

## Installation

1. Make sure you have Node.js installed (required for COC)

2. Install the extensions by opening Neovim and running:

```vim
:CocInstall coc-tsserver coc-json
```

## Configuration

The configuration files are:

- `lua/plugins/coc.lua`: Main COC configuration
- `coc-settings.json`: Settings for TypeScript server and diagnostics
- Modified `lsp.lua`: Disables TypeScript LSP for TypeScript files
- Modified `cmp.lua`: Disables nvim-cmp for TypeScript files

## How it works

- COC handles TypeScript/JavaScript completion and diagnostics
- COC's diagnostic popups are disabled to avoid duplicating your existing popups
- Native LSP is still used for all other keymaps and languages
- The LSP TypeScript server is disabled for TypeScript files
- nvim-cmp completion is disabled for TypeScript files

## Key combinations

COC autocompletion:
- `Tab`: Navigate completion menu forward
- `Shift+Tab`: Navigate completion menu backward
- `Enter`: Confirm selection
- `Ctrl+Space`: Manually trigger completion

Navigation:
- Continue using your existing diagnostic navigation keybinds
- All your which_key LSP mappings (`<leader>l...`) still work

## Troubleshooting

If you experience issues:

1. Check if COC is installed correctly:
   ```
   :CocInfo
   ```

2. Check if TypeScript server is running:
   ```
   :CocList services
   ```

3. If needed, restart the TypeScript server:
   ```
   :CocRestart
   ```

4. If you still see duplicate diagnostics popups, you can manually run:
   ```
   :let g:coc_diagnostic_disable_float = 1
   ```
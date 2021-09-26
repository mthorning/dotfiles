command! LspCodeAction lua require 'lv-utils'.code_action()
command! LspDeclaration lua require 'lv-utils'.declaration()
command! LspDefinition lua require 'lv-utils'.definition()
command! LspDocumentSymbol lua require 'lv-utils'.document_symbol()
command! LspFormatting lua require 'lv-utils'.formatting()
command! LspFormattingSync lua require 'lv-utils'.formatting_sync()
command! LspHover lua require 'lv-utils'.hover()
command! LspImplementation lua require 'lv-utils'.implementation()
command! LspRangeCodeAction lua require 'lv-utils'.range_code_action()
command! LspRangeFormatting lua require 'lv-utils'.range_formatting()
command! LspReferences lua require 'lv-utils'.references()
command! LspRename lua require 'lv-utils'.rename()
command! LspTypeDefinition lua require 'lv-utils'.type_definition()
command! LspWorkspaceSymbol lua require 'lv-utils'.workspace_symbol()
command! LspGotoNext lua require 'lv-utils'.goto_next()
command! LspGotoPrev lua require 'lv-utils'.goto_prev()
command! LspShowLineDiagnostics lua require 'lv-utils'.show_line_diagnostics()
command! NextHunk lua require 'lv-utils'.next_hunk()
command! PrevHunk lua require 'lv-utils'.prev_hunk()
command! StageHunk lua require 'lv-utils'.stage_hunk()
command! UndoStageHunk lua require 'lv-utils'.undo_stage_hunk()
command! ResetHunk lua require 'lv-utils'.reset_hunk()
command! ResetBuffer lua require 'lv-utils'.reset_buffer()
command! PreviewHunk lua require 'lv-utils'.preview_hunk()
command! BlameLine lua require 'lv-utils'.blame_line()
command! W noa w


autocmd! User GoyoEnter lua require('gitsigns').toggle_signs()
autocmd! User GoyoLeave lua require('gitsigns').toggle_signs()

autocmd User GoyoEnter set laststatus=0 
autocmd User GoyoLeave set laststatus=2

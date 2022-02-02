" vsnip snippet
syn match jsonSnippetTabstop '\$\d\+' containedin=jsonString
syn match jsonSnippetVariable '\$[A-Z_]\+' containedin=jsonString
syn cluster jsonSnippetMarks contains=jsonSnippetTabstop,jsonSnippetPlaceholder,jsonSnippetChoice
syn region jsonSnippetPlaceholder matchgroup=jsonSnippetTabstop
      \ start='\${\d\+:' end='}' oneline
      \ contains=@jsonSnippetMarks
      \ containedin=jsonString
syn region jsonSnippetChoice matchgroup=jsonSnippetTabstop
      \ start='\${\d\+|' end='|}' oneline
      \ contains=@jsonSnippetMarks,jsonSnippetChoiceDelimiter
      \ containedin=jsonString
syn match jsonSnippetChoiceDelimiter ',' contained

if get(g:, 'vsnip_syntax_vimexpr', v:true)
  syn include @vimExpr syntax/vim.vim
  syn region jsonSnippetVimExpr matchgroup=jsonSnippetTabstop
        \ start='\${VIM:' end='}' oneline keepend
        \ contains=@vimExpr containedin=jsonString
endif

hi def link jsonSnippetTabstop PreProc
hi def link jsonSnippetVariable Constant
hi def link jsonSnippetPlaceholder jsonString
hi def link jsonSnippetChoice jsonString
hi def link jsonSnippetChoiceDelimiter Delimiter

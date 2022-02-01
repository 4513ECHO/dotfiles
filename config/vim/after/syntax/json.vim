" vsnip snippet
syn match jsonSnippetTabstop /\$\d/ containedin=jsonString
syn region jsonSnippetTabstopDefault matchgroup=jsonSnippetTabstop
      \ start=+\${\d:+ skip=+\\}+ end=+}+ oneline
      \ containedin=jsonString
syn match jsonSnippetConstant /\$[A-Z_]\+/ containedin=jsonString

hi def link jsonSnippetTabstop Statement
hi def link jsonSnippetTabstopDefault String
hi def link jsonSnippetConstant Constant

" vim syntax file

if exists('b:current_syntax')
  finish
endif

syn match grammarComment /#.*$/
syn match grammarDefine /::=/
syn match grammarToken /[A-Z_]\+/
syn region grammarString start=/"/ end=/"/ oneline
syn region grammarString start=/'/ end=/'/ oneline
syn region grammarRegEx start='/' end='/' oneline
syn match grammarOr /|/
syn match grammarRepeat /+\|\*/
syn match grammarOption /\[\|]/
syn match grammarGroup /(\|)/
syn region grammarSymbol start=/</ end=/>/ oneline

hi def link grammarComment Comment
hi def link grammarDefine Define
hi def link grammarToken Constant
hi def link grammarString String
hi def link grammarRegEx String
hi def link grammarOr PreProc
hi def link grammarRepeat PreProc
hi def link grammarOption PreProc
hi def link grammarGroup PreProc
hi def link grammarSymbol Constant

let b:current_syntax = 'grammar'

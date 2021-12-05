" vim syntax file

if exists('b:current_syntax')
  finish
endif

syn match gitignoreComment /^#.*$/
syn match gitignoreEscaped /\V\\!\|\\*\|\\\\/
syn match gitignoreFile '[^/#!*\\]\+'
syn match gitignoreEexclamation /^!/
syn match gitignoreStar /\*/

hi def link gitignoreComment Comment
hi def link gitignoreEscaped SpecialChar
hi def link gitignoreFile Function
hi def link gitignoreEexclamation PreProc
hi def link gitignoreStar PreProc

let b:current_syntax = 'gitignore'

" vim syntax file

if exists("b:current_syntax")
  finish
endif

syn match robotstxtComment /#.*/
syn match robotstxtField /^[A-za-z\-]\+\ze:/
syn match robotstxtStar /*/
syn match robotstxtDollar /\$$/
syn match robotstxtURL `\v<%(https?://[^' <>"]+|%(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' <>"]+)[a-zA-Z0-9/]`

hi def link robotstxtComment Comment
hi def link robotstxtField Statement
hi def link robotstxtStar Special
hi def link robotstxtDollar Special
hi def link robotstxtURL Underlined

let b:current_syntax = "robots-txt"

if exists('b:did_indent')
  finish
endif
let b:did_indent = v:true

setlocal indentexpr=jq_indent#exec(v:lnum)
setlocal indentkeys+=0{,0},0(,0),0[,0],e,=end,=elif,=else,=catch

let b:undo_indent = 'setlocal '.. join([
      \ 'indentexpr<',
      \ 'indentkeys<',
      \ ])

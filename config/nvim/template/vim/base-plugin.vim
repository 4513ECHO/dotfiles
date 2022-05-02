if exists('g:loaded_{{_input_:plugin}}') || &cp
  finish
endif
let g:loaded_{{_input_:plugin}} = v:true

let s:save_cpo = &cpo
set cpo&vim

{{_cursor_}}

let &cpo = s:save_cpo
unlet s:save_cpo

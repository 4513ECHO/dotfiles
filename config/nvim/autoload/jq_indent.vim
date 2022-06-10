let s:TYPE_NORMAL = 'TYPE_NORMAL'
let s:TYPE_ONELINER = 'TYPE_ONELINER'
let s:TYPE_COMMENT = 'TYPE_COMMENT'
let s:TYPE_IF = 'TYPE_IF'
let s:TYPE_ELIF = 'TYPE_ELIF'
let s:TYPE_ELSE = 'TYPE_ELSE'
let s:TYPE_END = 'TYPE_END'
let s:TYPE_TRY = 'TYPE_TRY'
let s:TYPE_CATCH = 'TYPE_CATCH'
let s:TYPE_DEF = 'TYPE_DEF'
let s:TYPE_BLOCK = 'TYPE_BLOCK'
let s:TYPE_ENDBLOCK = 'TYPE_ENDBLOCK'

let s:BEGIN_LIST = [
      \ s:TYPE_DEF,
      \ s:TYPE_TRY,
      \ s:TYPE_CATCH,
      \ s:TYPE_IF,
      \ s:TYPE_ELSE,
      \ s:TYPE_ELIF,
      \ s:TYPE_BLOCK,
      \ ]

let s:END_LIST = [
      \ s:TYPE_CATCH,
      \ s:TYPE_END,
      \ s:TYPE_ELSE,
      \ s:TYPE_ELIF,
      \ s:TYPE_ENDBLOCK,
      \ ]

let g:jq_indent#debug = get(g:, 'jq_indent#debug', v:true)

function! jq_indent#exec(lnum) abort
  if a:lnum == 1
    return 0
  endif
  let [curr_type, text] = jq_indent#get_type(getline(a:lnum), a:lnum)
  let prev_lnum = prevnonblank(a:lnum - 1)
  let [prev_type, _] = jq_indent#get_type(getline(prev_lnum), prev_lnum)
  let n = indent(prev_lnum)
  if index(s:END_LIST, curr_type) != -1
    if index(s:BEGIN_LIST, prev_type) == -1
      let n -= shiftwidth()
    endif
  else
    if index(s:BEGIN_LIST, prev_type) != -1
      let n += shiftwidth()
    endif
  endif
  if g:jq_indent#debug
    echomsg {'prev': [prev_lnum, prev_type], 'curr': [a:lnum, curr_type], 'n': n, 'text': text}
  endif
  return n
endfunction

function! jq_indent#get_type(line, lnum) abort
  " Remove indent, trailing space and prefix pipe
  let text = matchstr(a:line, '^\s*\%(|\s*\)\?\zs\S.*\ze\s*$')
  let t = s:TYPE_NORMAL
  if text =~# '^#'
    let t = s:TYPE_COMMENT
  elseif text =~# '[{([]$'
    let t = s:TYPE_BLOCK
  elseif text =~# '\v^[})\]](\[\])?$'
    let t = s:TYPE_ENDBLOCK
  elseif text =~# '^\<if\>.*\<then\>.*\<end\>$'
    let t = s:TYPE_ONELINER
  elseif text =~# '^\<try\>.*\<catch\>.*$'
    let t = s:TYPE_ONELINER
    " elseif text =~# '^\<def\>.*;$'
    "   let t = s:TYPE_ONELINER
  elseif text =~# '^\<if\>'
    let t = s:TYPE_IF
  elseif text =~# '^\<elif\>'
    let t = s:TYPE_ELIF
  elseif text =~# '^\<else\>'
    let t = s:TYPE_ELSE
  elseif text =~# '^\<end\>'
    let t = s:TYPE_END
  elseif text =~# '^\<try\>'
    let t = s:TYPE_TRY
  elseif text =~# '^\<catch\>'
    let t = s:TYPE_CATCH
  elseif text =~# '^\<def\>'
    let t = s:TYPE_DEF " TODO: handle ; as end of function
  endif
  return [t, text]
endfunction

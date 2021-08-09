setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal smarttab

let python_highlight_all = 1

" f-string
syn match pythonEscape +{{+ contained containedin=pythonfString,pythonfDocstring
syn match pythonEscape +}}+ contained containedin=pythonfString,pythonfDocstring

syn region pythonfString matchgroup=pythonQuotes
  \ start=+[fF]\@1<=\z(['"]\)+ end="\z1"
  \ contains=@Spell,pythonEscape,pythonInterpolation

syn region pythonfDocstring matchgroup=pythonQuotes
  \ start=+[fF]\@1<=\z('''\|"""\)+ end="""\z1" keepend
  \ contains=@Spell,pythonEscape,pythonSpaceError,pythonInterpolation,pythonDoctest

syn region pythonInterpolation contained
  \ matchgroup=SpecialChar
  \ start=+{{\@!+ end=+}}\@!+ skip=+{{+ keepend
  \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue,pythonDoctest

syn match pythonStringModifier /:\(.[<^=>]\)\?[-+ ]\?#\?0\?[0-9]*[_,]\?\(\.[0-9]*\)\?[bcdeEfFgGnosxX%]\?/ contained containedin=pythonInterpolation
syn match pythonStringModifier /![sra]/ contained containedin=pythonInterpolation

hi link pythonfString String
hi link pyhonfDocstring String
hi link pythonStringModifier PreProc


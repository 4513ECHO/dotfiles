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

hi def link pythonfString String
hi def link pyhonfDocstring String
hi def link pythonStringModifier PreProc

" Boolean
syn keyword pythonBoolean True False None
hi def link pythonBoolean Boolean


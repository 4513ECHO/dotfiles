" Boolean (for Vim9)
syn match vimBoolean /\v%(v:)?%(true|false)/ containedin=vimIsCommand,vimVar,vimFBVar
hi def link vimBoolean Boolean

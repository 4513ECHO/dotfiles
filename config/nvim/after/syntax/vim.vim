" Boolean
syn match vimBoolean /v:true\|v:false/
hi def link vimBoolean Boolean
syn cluster vimOperGroup add=vimBoolean

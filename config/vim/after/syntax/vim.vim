syn match vimBoolean /v:true\|v:false/
hi def link vimBoolean Boolean
syn cluster vimOperGroup contains=vimEnvvar,vimFunc,vimFuncVar,vimOper,vimOperParen,vimNumber,vimString,vimBoolean,vimType,vimRegister,vimContinue,vim9Comment

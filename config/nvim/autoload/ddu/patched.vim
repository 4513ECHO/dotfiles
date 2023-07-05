" NOTE: Ensure config is loaded that is set from ddu#custom#load_config()
function! ddu#patched#start(options = {}) abort
  if g:->get('loaded_ddu_config')
    call ddu#start(a:options)
  else
    call dein#source('ddu.vim')
    let s:options = a:options
    autocmd vimrc User DduConfigLoaded ++once call ddu#start(s:options)
  endif
endfunction

function! ddu#patched#commands(args) abort
  call ddu#patched#start(ddu#commands#_parse_options_args(a:args))
endfunction

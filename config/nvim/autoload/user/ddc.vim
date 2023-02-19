function! user#ddc#cmdline_pre(mode) abort
  if g:denops#disabled
    return
  endif
  " NOTE: I have to define map each time because I sometimes use default
  " cmdline completion with `g:`
  cnoremap <expr> <Tab> pum#visible()
        \ ? '<Cmd>call pum#map#longest_relative(+1)<CR>'
        \ : ddc#map#manual_complete()
  set wildcharm=<C-l>

  let b:ddc_cmdline_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(get(s:patch_buffer, a:mode, {}))
  autocmd vimrc User DDCCmdlineLeave ++once call user#ddc#cmdline_post()
  autocmd vimrc InsertEnter <buffer> ++once call user#ddc#cmdline_post()
  call ddc#enable_cmdline_completion()
endfunction

let s:patch_buffer = {':': {}, '/': {}}
let s:patch_buffer[':'].cmdlineSources = ['cmdline', 'around']
let s:patch_buffer[':'].keywordPattern = '[0-9a-zA-Z_:#-]*'
let s:patch_buffer[':'].sourceOptions = #{
      \ cmdline: #{
      \   forceCompletionPattern: '[\w@:~._-]/[\w@:~._-]*',
      \ }}
let s:patch_buffer['/'].cmdlineSources = ['around']
let s:patch_buffer['/'].sourceOptions = #{
      \ around: #{
      \   minAutoCompleteLength: 1,
      \ }}

function! user#ddc#cmdline_post() abort
  if exists('b:ddc_cmdline_config')
    call ddc#custom#set_buffer(b:ddc_cmdline_config)
    unlet b:ddc_cmdline_config
  endif
  silent! cunmap <Tab>
  set wildcharm&
endfunction

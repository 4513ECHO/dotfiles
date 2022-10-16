function! user#ddc#cmdline_pre(mode) abort
  if g:denops#disabled
    return
  endif
  " NOTE: I have to define map each time because I sometimes use default
  " cmdline completion with `g:`
  call user#ddc#define_map('c', '<Tab>', 'pum#map#select_relative(+1)',
       \ 'ddc#map#manual_complete()', v:true)
  set wildcharm=<C-l>

  let b:_ddc_cmdline_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(get(s:patch_buffer, a:mode, {}))
  autocmd vimrc User DDCCmdlineLeave ++once call user#ddc#cmdline_post()
  autocmd vimrc InsertEnter <buffer> ++once call user#ddc#cmdline_post()
  call ddc#enable_cmdline_completion()
endfunction

let s:patch_buffer = {':': {}, '/': {}}
let s:patch_buffer[':'].cmdlineSources = ['cmdline', 'around']
let s:patch_buffer[':'].keywordPattern = '[0-9a-zA-Z_:#-]*'
let s:patch_buffer[':'].sourceOptions = {
      \ 'cmdline': {
      \   'forceCompletionPattern': '[\w@:~._-]/[\w@:~._-]*',
      \ }}
let s:patch_buffer['/'].cmdlineSources = ['around']
let s:patch_buffer['/'].sourceOptions = {
      \ 'around': {
      \   'minAutoCompleteLength': 1,
      \ }}

function! user#ddc#define_map(mode, lhs, func, rhs, ...) abort
  let rhs = get(a:000, 0, v:false) ? a:rhs : "'" .. a:rhs .. "'"
  let cmd = '%snoremap <expr> %s ' ..
        \ 'pum#visible() ? ''<Cmd>call %s<CR>'' : %s'
  execute printf(cmd, a:mode, a:lhs, a:func, rhs)
endfunction

function! user#ddc#cmdline_post() abort
  if exists('b:_ddc_cmdline_prev_buffer_config')
    call ddc#custom#set_buffer(b:_ddc_cmdline_prev_buffer_config)
    unlet b:_ddc_cmdline_prev_buffer_config
  endif
  silent! cunmap <Tab>
  set wildcharm&
endfunction

function! user#ddc#skkeleton_pre() abort
  let b:_ddc_skkeleton_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer({'sources': ['skkeleton']})
endfunction

function! user#ddc#skkeleton_post() abort
  if exists('b:_ddc_skkeleton_prev_buffer_config')
    call ddc#custom#set_buffer(b:_ddc_skkeleton_prev_buffer_config)
    unlet b:_ddc_skkeleton_prev_buffer_config
  endif
endfunction

function! user#ddc#imap_cr() abort
  if pum#visible()
    return "\<Cmd>call pum#map#confirm()\<CR>"
  else
    return lexima#expand('<CR>', 'i')
  endif
endfunction

function! user#ddc#imap_bs() abort
  if pum#visible()
    return "\<Cmd>call pum#map#cancel()\<CR>"
  else
    return lexima#expand('<BS>', 'i')
  endif
endfunction


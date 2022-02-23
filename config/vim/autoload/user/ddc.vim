function! user#ddc#cmdline_pre(mode) abort
  if g:denops#disabled
    return
  endif
  cnoremap <expr> <Tab> pum#visible()
        \ ? '<Cmd>call pum#map#select_relative(+1)<CR>'
        \ : ddc#map#manual_complete()
  call user#ddc#define_map('c', '<C-n>', 'pum#map#select_relative(+1)', '<Down>')
  call user#ddc#define_map('c', '<C-p>', 'pum#map#select_relative(-1)', '<Up>')
  call user#ddc#define_map('c', '<CR>',  'pum#map#confirm()', '<CR>')
  call user#ddc#define_map('c', '<BS>',  'pum#map#cancel()',  '<BS>')
  set wildchar=<C-l>

  let b:_ddc_cmdline_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(get(s:patch_buffer, a:mode, {}))
  autocmd vimrc User DDCCmdlineLeave ++once call user#ddc#cmdline_post()
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction

let s:patch_buffer = {':': {}, '/': {}}
let s:patch_buffer[':'].sources = ['cmdline', 'around']
let s:patch_buffer[':'].keywordPattern = '[0-9a-zA-Z_:#-]*'
let s:patch_buffer[':'].sourceOptions = {
      \ 'cmdline': {
      \   'forceCompletionPattern': '(\f*/\f+)+',
      \ }}
let s:patch_buffer['/'].sources = ['around']
let s:patch_buffer['/'].sourceOptions = {
      \ 'around': {
      \   'minAutoCompleteLength': 1,
      \ }}

function! user#ddc#define_map(mode, lhs, func, rhs) abort
  let cmd = '%snoremap <expr> %s ' ..
        \ 'pum#visible() ? ''<Cmd>call %s<CR>'' : ''%s'''
  execute printf(cmd, a:mode, a:lhs, a:func, a:rhs)
endfunction

function! user#ddc#cmdline_post() abort
  if exists('b:_ddc_cmdline_prev_buffer_config')
    call ddc#custom#set_buffer(b:_ddc_cmdline_prev_buffer_config)
  endif
  silent! cunmap <Tab>
  set wildchar&
endfunction

function! user#ddc#skkeleton_pre() abort
  let b:skkeleton_enabled = v:true
  let b:_ddc_skkeleton_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer({'sources': ['skkeleton']})
endfunction

function! user#ddc#skkeleton_post() abort
  if exists('b:skkeleton_enabled')
    unlet b:skkeleton_enabled
  endif
  if exists('b:_ddc_skkeleton_prev_buffer_config')
    call ddc#custom#set_buffer(b:_ddc_skkeleton_prev_buffer_config)
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


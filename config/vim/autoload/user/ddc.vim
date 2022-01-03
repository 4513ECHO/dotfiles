function! user#ddc#cmdline_pre(mode) abort
  if g:denops#disabled
    return
  endif
  call dein#source('ddc.vim')
  call user#ddc#define_map('c', '<Tab>', 'pum#map#select_relative(+1)',
        \ 'ddc#map#manual_complete()')
  call user#ddc#define_map('c', '<C-n>', 'pum#map#select_relative(+1)', '<Down>')
  call user#ddc#define_map('c', '<C-p>', 'pum#map#select_relative(-1)', '<Up>')
  call user#ddc#define_map('c', '<CR>',  'pum#map#confirm()', '<CR>')
  " call user#ddc#define_map('c', '<BS>',  'pum#map#cancel()',  '<BS>')
  set wildchar=<C-t>

  let b:_ddc_cmdline_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(s:patch_buffer)
  autocmd user User DDCCmdlineLeave ++once call user#ddc#cmdline_post()
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction

let s:patch_buffer = {}
let s:patch_buffer.sources = ['cmdline', 'around']
let s:patch_buffer.keywordPattern = '[0-9a-zA-Z_:#-]*'
let s:patch_buffer.sourceOptions = {
      \ 'cmdline': {
      \   'forceCompletionPattern': '(\f*/\f+)+',
      \ }}

function! user#ddc#define_map(mode, lhs, rhs_func, rhs_nopum) abort
  execute printf(
        \ '%snoremap <silent><expr> %s ' ..
        \ 'pum#visible() ? ''<Cmd>call %s<CR>'' : ''%s''',
        \ a:mode, a:lhs, a:rhs_func, a:rhs_nopum
        \ )
endfunction

function! user#ddc#cmdline_post() abort
  if exists('b:_ddc_cmdline_prev_buffer_config')
    call ddc#custom#set_buffer(b:_ddc_cmdline_prev_buffer_config)
    unlet b:_ddc_cmdline_prev_buffer_config
  endif
  cunmap <Tab>
  set wildchar=<Tab>
endfunction

function! user#ddc#skkeleton_pre() abort
  let b:skkeleton_enabled = v:true
  let b:_ddc_skkeleton_prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! user#ddc#skkeleton_post() abort
  if exists('b:skkeleton_enabled')
    unlet b:skkeleton_enabled
  endif
  if exists('b:_ddc_skkeleton_prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:_ddc_skkeleton_prev_buffer_config
  endif
endfunction

function! user#ddc#imap_cr() abort
  if pum#visible()
    call pum#map#confirm()
    return ''
  else
    return lexima#expand('<CR>', 'i')
  endif
endfunction

function! user#ddc#imap_bs() abort
  if pum#visible()
    call pum#map#cancel()
    return ''
  else
    return lexima#expand('<BS>', 'i')
  endif
endfunction


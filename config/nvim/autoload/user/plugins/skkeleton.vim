" Show mode on virtual text
" original code by @uga-rosa
" based on https://github.com/kuuote/dotvim/blob/6a69151c/conf/plug/skkeleton.lua#L32

let s:skkeleton_modes = #{
      \ hira: 'あ',
      \ kata: 'ア',
      \ hankata: 'ｧｱ',
      \ zenkaku: 'ａ',
      \ abbrev: '/a',
      \ }

if has('nvim')
  let s:ns = nvim_create_namespace('skkeleton')
  let s:id = 1234
  function! s:set() abort
    let skk_mode = skkeleton#mode()
    call nvim_buf_set_extmark(0, s:ns, line('.') - 1, col('.') - 1, #{
          \ id: s:id,
          \ virt_text: [[
          \   s:skkeleton_modes->get(skk_mode, skk_mode),
          \   'PmenuSel',
          \ ]],
          \ virt_text_pos: 'eol',
          \ })
  endfunction

  function! s:reset() abort
    call nvim_buf_del_extmark(0, s:ns, s:id)
  endfunction
else
  let s:prop_type = 'skkeleton_show_mode'
  call prop_type_add(s:prop_type, #{ highlight: 'PmenuSel' })
  function! s:set() abort
    call s:reset()
    let skk_mode = skkeleton#mode()
    call prop_add(line('.'), 0, #{
          \ type: s:prop_type,
          \ text: s:skkeleton_modes->get(skk_mode, skk_mode),
          \ text_align: 'after',
          \ })
  endfunction

  function! s:reset() abort
    call prop_remove(#{ type: s:prop_type })
  endfunction
endif

function! user#plugins#skkeleton#show_mode() abort
  call s:set()
  augroup skkeleton_show_mode
    autocmd!
    autocmd CursorMovedI * call s:set()
  augroup END
endfunction

function! user#plugins#skkeleton#hide_mode() abort
  augroup skkeleton_show_mode
    autocmd!
  augroup END
  call s:reset()
endfunction

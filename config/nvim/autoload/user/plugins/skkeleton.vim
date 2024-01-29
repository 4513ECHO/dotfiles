" Show mode and henkan state on virtual text
" original code by @uga-rosa and @kawarimidoll
" based on https://github.com/kuuote/dotvim/blob/6a69151c/conf/plug/skkeleton.lua#L32
"          https://zenn.dev/link/comments/35eef680583339

let s:skk_modes = #{
      \ hira: 'あ',
      \ kata: 'ア',
      \ hankata: 'ｧｱ',
      \ zenkaku: 'ａ',
      \ abbrev: '/a',
      \ }
let s:prev_phase = ''

if has('nvim')
  let s:ns = nvim_create_namespace('skkeleton')
  let s:mode_id = 42
  let s:state_id = 4242
  function! s:set() abort
    let skk_mode = skkeleton#mode()
    call nvim_buf_set_extmark(0, s:ns, line('.') - 1, col('.') - 1, #{
          \ id: s:mode_id,
          \ virt_text: [[s:skk_modes->get(skk_mode, skk_mode), 'PmenuSel']],
          \ virt_text_pos: 'eol',
          \ })
  endfunction
  function! s:show_phase(marker, new) abort
    let [row, col] = a:new ?
          \   [line('.') - 1, col('.') - 1]
          \ : nvim_buf_get_extmark_by_id(0, s:ns, s:state_id, {})
    call nvim_buf_set_extmark(0, s:ns, row, col, #{
          \ id: s:state_id,
          \ virt_text: [[a:marker, 'PmenuSel']],
          \ virt_text_pos: 'inline',
          \ right_gravity: v:false,
          \ })
  endfunction

  function! s:reset() abort
    call nvim_buf_clear_namespace(0, s:ns, 0, -1)
  endfunction
  function! s:reset_phase() abort
    call nvim_buf_del_extmark(0, s:ns, s:state_id)
  endfunction
else
  let s:prop_type = 'skkeleton_show_mode'
  let s:prop_type_phase = 'skkeleton_show_phase'
  call prop_type_add(s:prop_type, #{ highlight: 'PmenuSel' })
  call prop_type_add(s:prop_type_phase, #{ highlight: 'PmenuSel', start_incl: v:true })
  function! s:set() abort
    call s:reset()
    let skk_mode = skkeleton#mode()
    call prop_add(line('.'), 0, #{
          \ type: s:prop_type,
          \ text: s:skk_modes->get(skk_mode, skk_mode),
          \ text_align: 'after',
          \ })
  endfunction

  function! s:show_phase(marker, new) abort
    let coord = a:new ?
          \   #{ lnum: line('.'), col: col('.') }
          \ : prop_find(#{ type: s:prop_type_phase })
    call s:reset_phase()
    call prop_add(coord.lnum, coord.col, #{
          \ type: s:prop_type_phase,
          \ text: a:marker,
          \ })
  endfunction

  function! s:reset() abort
    call prop_remove(#{ type: s:prop_type })
  endfunction
  function! s:reset_phase() abort
    call prop_remove(#{ type: s:prop_type_phase })
  endfunction
endif

function! user#plugins#skkeleton#show_mode() abort
  call s:set()
  if g:skkeleton#state.phase !=# s:prev_phase
    let phase = g:skkeleton#state.phase
    if phase ==# 'input:okurinasi'
      call s:show_phase('▽', v:true)
    elseif phase ==# 'input:okuriari'
      call s:show_phase(s:prev_phase ==# 'input:okurinasi' ? '▽' : '▼', v:false)
    elseif phase ==# 'henkan'
      call s:show_phase('▼', v:false)
    else
      call s:reset_phase()
    endif
  endif
  let s:prev_phase = g:skkeleton#state.phase
endfunction

function! user#plugins#skkeleton#hide_mode() abort
  call s:reset()
  call s:reset_phase()
endfunction

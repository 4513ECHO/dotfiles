function! s:on_changed() abort
  if has('nvim')
    " NOTE: eob of 'fillchars' is annoying
    let bgcolor = nvim_get_hl(0, #{ name: 'Normal' })
          \ ->get('bg', 0x000000)
          \ ->printf('#%06x')
    call nvim_set_hl(0, 'DduEndOfBuffer', #{
          \ foreground: bgcolor,
          \ background: bgcolor,
          \ default: v:true,
          \ })
  endif
  let options = #{ uiParams: #{ ff: {} } }
  let options.uiParams.ff = #{
        \ previewWidth: &columns / 3 * 2,
        \ winCol: &columns / 6,
        \ winHeight: &lines / 3 * 2,
        \ winRow: &lines / 6,
        \ winWidth: &columns / 3 * 2,
        \ }
  call ddu#custom#patch_global(options)
  call ddu#ui#do_action('updateOptions', options)
endfunction

let s:lightline_timer = -1
function! s:update_lightline() abort
  call timer_stop(s:lightline_timer)
  let s:lightline_timer = timer_start(200, { -> s:update_lightline_impl() })
endfunction
function! s:update_lightline_impl() abort
  call lightline#update()
  redrawstatus
endfunction

autocmd vimrc ColorScheme,VimResized * call s:on_changed()
autocmd vimrc CursorMoved,TextChangedI ddu-ff-* call s:update_lightline()
call ddu#custom#action('ui', 'ff', 'updateLightline', { -> s:update_lightline() })
call s:on_changed()

call ddu#custom#patch_local('with_preview', 'uiParams', #{
      \ ff: #{
      \   autoAction: #{ name: 'preview' },
      \   previewCol: &columns / 2,
      \   previewHeight: &lines / 3 * 2,
      \   previewRow: &lines / 6,
      \   previewSplit: 'vertical',
      \   previewWidth: &columns / 3,
      \   winWidth: &columns / 3,
      \ },
      \ })

call ddu#custom#load_config(expand('$DEIN_DIR/settings/ddu.ts'))

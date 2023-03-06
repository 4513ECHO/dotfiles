let s:skk_dir = expand('~/.local/share/skk')
let s:globalJisyo = s:skk_dir .. '/SKK-JISYO.L'

if filereadable('/usr/share/skk/SKK-JISYO.L')
  let s:globalJisyo = '/usr/share/skk/SKK-JISYO.L'
elseif !filereadable(s:globalJisyo)
  echomsg 'Installing skk global jisyo ...'
  let s:gzipfile = s:globalJisyo .. '.gz'
  call system('curl -fLo ' .. s:gzipfile .. ' --create-dirs '
        \ .. 'https://skk-dev.github.io/dict/SKK-JISYO.L.gz')
  call system('gzip -d ' .. s:gzipfile)
endif

call skkeleton#config(#{
      \ eggLikeNewline: v:true,
      \ completionRankFile: s:skk_dir .. '/completionRankFile',
      \ globalDictionaries: [[s:globalJisyo, 'euc-jp']],
      \ keepState: v:true,
      \ registerConvertResult: v:true,
      \ userJisyo: s:skk_dir .. '/SKK-JISYO.user',
      \ })

call skkeleton#register_kanatable('rom', {
      \ "z\<Space>": ["\u3000"],
      \ })

function! s:on_enable() abort
  let b:skkeleton_config = ddc#custom#get_buffer()
  " call ddc#custom#patch_buffer(#{
  "      \ sources: ['skkeleton'],
  "      \ specialBufferCompletion: v:true,
  "      \ })
  call ddc#custom#patch_buffer(#{ sources: [] })
endfunction
function! s:on_disable() abort
  if exists('b:skkeleton_config')
    call ddc#custom#set_buffer(b:skkeleton_config)
    unlet b:skkeleton_config
  endif
endfunction

autocmd vimrc User skkeleton-enable-pre call s:on_enable()
autocmd vimrc User skkeleton-disable-pre call s:on_disable()
autocmd vimrc User skkeleton-enable-post call lightline#update()
autocmd vimrc User skkeleton-mode-changed call lightline#update()

" Show mode on virtual text
" original code by @uga-rosa
" based on https://github.com/kuuote/dotvim/blob/6a69151c/conf/plug/skkeleton.lua#L32

let s:skkeleton_modes = {
      \ 'hira': 'あ',
      \ 'kata': 'ア',
      \ 'hankata': 'ｧｱ',
      \ 'zenkaku': 'ａ',
      \ 'abbrev': '/a',
      \ }

if has('nvim')
  let s:ns = nvim_create_namespace('skkeleton')
  let s:id = 1234
  function! s:set() abort
    call nvim_buf_set_extmark(0, s:ns, line('.') - 1, col('.') - 1, #{
          \ id: s:id,
          \ virt_text: [[
          \   get(s:skkeleton_modes, skkeleton#mode(), skkeleton#mode()),
          \   'PmenuSel']],
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
    call prop_add(line('.'), 0, #{
          \ type: s:prop_type,
          \ text: get(s:skkeleton_modes, skkeleton#mode(), skkeleton#mode()),
          \ text_align: 'after',
          \ })
  endfunction
  function! s:reset() abort
    call prop_remove(#{ type: s:prop_type })
  endfunction
endif

function! s:show_mode_enable() abort
  augroup skkeleton_show_mode
    autocmd!
    autocmd CursorMovedI * call s:set()
  augroup END
endfunction
function! s:show_mode_disable() abort
  augroup skkeleton_show_mode
    autocmd!
  augroup END
  call s:reset()
endfunction

autocmd vimrc User skkeleton-enable-post call s:show_mode_enable()
autocmd vimrc User skkeleton-disable-post call s:show_mode_disable()

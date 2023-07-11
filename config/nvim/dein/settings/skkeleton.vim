" hook_add {{{
noremap! <C-j> <Plug>(skkeleton-toggle)
tnoremap <C-\><C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
let s:skk_dir = expand('~/.local/share/skk')
let s:globalJisyo = denops#request('vimrc', 'downloadJisyo', [s:skk_dir])

function! s:on_init() abort
  call skkeleton#config(#{
        \ eggLikeNewline: v:true,
        \ completionRankFile: s:skk_dir .. '/completionRankFile',
        \ globalDictionaries: [
        \   s:skk_dir .. '/SKK-JISYO.4513echo',
        \   [s:globalJisyo, 'euc-jp'],
        \ ],
        \ immediatelyCancel: v:false,
        \ keepState: v:true,
        \ registerConvertResult: v:true,
        \ showCandidatesCount: 2,
        \ userJisyo: s:skk_dir .. '/SKK-JISYO.user',
        \ })

  call skkeleton#register_keymap('input', ';', 'henkanPoint')

  " NOTE: z0 is from https://github.com/yasunori-kirin0418/dotfiles/blob/c5863428/config/nvim/autoload/vimrc.vim#L122
  call skkeleton#register_kanatable('rom', {
        \ 'z0': ["\u25CB"],
        \ '(': ["\uFF08"],
        \ ')': ["\uFF09"],
        \ })
endfunction

function! s:on_enable() abort
  let b:skkeleton_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(#{
        \ sources: ['skkeleton'],
        \ specialBufferCompletion: v:true,
        \ })
  call pum#set_buffer_option(#{ auto_select: v:false })
endfunction
function! s:on_disable() abort
  if exists('b:skkeleton_config')
    call ddc#custom#set_buffer(b:skkeleton_config)
    call pum#set_buffer_option(#{ auto_select: v:true })
    unlet b:skkeleton_config
  endif
endfunction

autocmd vimrc User skkeleton-initialize-pre call s:on_init()
autocmd vimrc User skkeleton-enable-pre call s:on_enable()
autocmd vimrc User skkeleton-disable-pre call s:on_disable()
autocmd vimrc User skkeleton-enable-post,skkeleton-mode-changed call lightline#update()

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

function! s:show_mode_enable() abort
  call s:set()
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
" }}}

" hook_add {{{
noremap! <C-j> <Plug>(skkeleton-toggle)
tnoremap <C-\><C-j> <Plug>(skkeleton-toggle)
autocmd vimrc User DenopsPluginPost:skkeleton call skkeleton#initialize()
" }}}

" hook_source {{{
autocmd vimrc User skkeleton-initialize-pre call s:on_init()
autocmd vimrc User skkeleton-enable-pre call s:on_enable()
autocmd vimrc User skkeleton-disable-pre call s:on_disable()
autocmd vimrc User skkeleton-enable-post,skkeleton-mode-changed call lightline#update()

autocmd vimrc User skkeleton-handled  call user#plugins#skkeleton#show_mode()
autocmd vimrc User skkeleton-disable-post call user#plugins#skkeleton#hide_mode()
autocmd vimrc User PumCompleteDone call user#plugins#skkeleton#hide_mode()

function! s:on_init() abort
  let skk_dir = has('mac') ?
        \   expand('~/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries')
        \ : expand('~/.local/share/skk')
  let globalJisyo = denops#request('vimrc', 'downloadJisyo', [skk_dir])

  call skkeleton#config(#{
        \ eggLikeNewline: v:true,
        \ completionRankFile: skk_dir .. '/completionRankFile',
        \ databasePath: skk_dir .. '/skk.db',
        \ globalDictionaries: [
        \   skk_dir .. '/SKK-JISYO.4513echo',
        \   skk_dir .. '/SKK-JISYO.bluearchive',
        \   skk_dir .. '/SKK-JISYO.scp',
        \   globalJisyo,
        \   skk_dir .. '/SKK-JISYO.emoji-ja',
        \ ],
        \ immediatelyCancel: v:false,
        \ keepState: v:true,
        \ markerHenkan: '',
        \ markerHenkanSelect: '',
        \ registerConvertResult: v:true,
        \ showCandidatesCount: 2,
        \ sources: ['deno_kv'],
        \ userDictionary: skk_dir ..
        \   (has('mac') ? '/skk-jisyo.utf-8' : '/SKK-JISYO.user'),
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
        \ cmdlineSources: ['skkeleton'],
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
" }}}

let s:skk_dir = expand('~/.local/share/skk')
let s:globalJisyo = s:skk_dir .. '/SKK-JISYO.L'

if !filereadable(s:globalJisyo)
  echomsg 'Installing skk global jisyo ...'
  let s:gzipfile = s:globalJisyo .. '.gz'
  call system('curl -fLo ' .. s:gzipfile .. ' --create-dirs '
        \ .. 'https://skk-dev.github.io/dict/SKK-JISYO.L.gz')
  call system('gzip -d ' .. s:gzipfile)
endif

call skkeleton#config({
      \ 'eggLikeNewline': v:true,
      \ 'registerConvertResult': v:true,
      \ 'globalJisyo': s:globalJisyo,
      \ 'userJisyo': s:skk_dir .. '/SKK-JISYO.user',
      \ })

call skkeleton#register_kanatable('rom', {
      \ ',,': 'escape',
      \ ';':  'henkanPoint',
      \ '~':         ['〜',     ''],
      \ '...':       ['…',     ''],
      \ ",\<Space>": ['、',     ''],
      \ "z\<Space>": ["\u3000", ''],
      \ ".\<Space>": ['。',     ''],
      \ "(\<Space>": ['（',     ''],
      \ ")\<Space>": ['）',     ''],
      \ "/\<Space>": ['・',     ''],
      \ })

" from https://github.com/thinca/config/blob/5413e42a18/dotfiles/dot.vim/vimrc#L2289
function s:skkeleton_enable_pre_unix() abort
  silent !echo -ne '\e]12;\#FFA500\a'
endfunction

function s:skkeleton_disable_post_unix() abort
  silent !echo -ne '\e]12;\#FFFFFF\a'
endfunction

autocmd user User skkeleton-enable-pre call user#ddc#skkeleton_pre()
autocmd user User skkeleton-disable-pre call user#ddc#skkeleton_post()
if !has('gui_running') && has('unix')
  autocmd user User skkeleton-enable-pre call <SID>skkeleton_enable_pre_unix()
  autocmd user User skkeleton-disable-post call <SID>skkeleton_disable_post_unix()
endif
if exists('*lightline#update')
  autocmd user User skkeleton-enable-post call lightline#update()
  autocmd user User skkeleton-mode-changed call lightline#update()
endif

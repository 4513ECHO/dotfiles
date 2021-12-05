let s:skk_dir = expand('~/.local/share/skk')
let s:globalJisyo = s:skk_dir .. '/SKK-JISYO.L'

if !filereadable(s:globalJisyo)
  echomsg 'Installing skk global jisyo ...'
  let gzipfile = s:globalJisyo .. '.gz'
  call system('curl -fLo ' .. gzipfile .. ' --create-dirs '
        \ .. 'https://skk-dev.github.io/dict/SKK-JISYO.L.gz')
  call system('gzip -d ' .. gzipfile)
endif

call skkeleton#config({
      \ 'eggLikeNewline': v:true,
      \ 'registerConvertResult': v:true,
      \ 'globalJisyo': s:globalJisyo,
      \ 'userJisyo': s:skk_dir .. '/SKK-JISYO.user',
      \ })

call skkeleton#register_kanatable('rom', {
      \ ',,': 'escape',
      \ ",\<Space>": ['、', ''],
      \ '~': ['〜', ''],
      \ "z\<Space>": ["\u3000", ''],
      \ '...': ['…', ''],
      \ ".\<Space>": ['。', ''],
      \ })

autocmd user User skkeleton-enable-pre call user#ddc#skkeleton_pre()
autocmd user User skkeleton-disable-pre call user#ddc#skkeleton_post()
if exists('*lightline#update')
  autocmd user User skkeleton-enable-post call lightline#update()
  autocmd user User skkeleton-mode-changed call lightline#update()
endif

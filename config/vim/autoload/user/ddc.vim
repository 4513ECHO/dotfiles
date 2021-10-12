function! user#ddc#cmdline_pre() abort
  call dein#source('ddc.vim')
  cnoremap <silent><expr> <Tab>
        \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>'
        \ : ddc#manual_complete()
  cnoremap <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
  cnoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
  cnoremap <silent><expr> <CR>
       \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>'
       \ : '<CR>'
  cnoremap <C-y> <Cmd>call pum#map#confirm()<CR>
  cnoremap <C-e> <Cmd>call pum#map#cancel()<CR>

  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources',
        \ ['necovim', 'cmdline-history', 'file', 'around'])
  autocmd user CmdlineLeave * ++once call user#ddc#cmdline_pre()
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction

function! user#ddc#cmdline_post() abort
  call ddc#custom#set_buffer(s:prev_buffer_config)
  cunmap <Tab>
endfunction


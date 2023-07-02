function! user#ddc#cmdline_pre(mode) abort
  " NOTE: I have to define map each time because I sometimes use default
  " cmdline completion with `g:`
  cnoremap <expr> <Tab> pum#visible()
        \ ? '<Cmd>call pum#map#longest_relative(+1)<CR>'
        \ : ddc#map#manual_complete()

  call ddc#enable_cmdline_completion()
endfunction

function! user#ddc#cmdline_post() abort
  silent! cunmap <Tab>
endfunction

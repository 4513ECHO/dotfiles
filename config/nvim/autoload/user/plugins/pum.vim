if has('nvim')
  function! user#plugins#pum#reverse_hl(name) abort
    let hl = nvim_get_hl(0, #{ name: a:name, link: v:false })
    if !hl->get('reverse', v:false)
      return
    endif
    unlet hl.reverse
    let [fg, bg] = [hl->get('fg', v:null), hl->get('bg', v:null)]
    eval hl ->extend(fg isnot# v:null ? #{ bg: fg->printf('#%06x') } : {})
          \ ->extend(bg isnot# v:null ? #{ fg: bg->printf('#%06x') } : {})
          \ ->{ hl -> nvim_set_hl(0, 'PmenuSel', hl) }()
  endfunction
else
  function! user#plugins#pum#reverse_hl(name) abort
    let [hl] = hlget(a:name, v:true)
    if !hl->get('gui', {})->get('reverse', v:false)
      return
    endif
    unlet hl.gui.reverse hl.cterm.reverse
    let [fg, bg] = [hl->get('guifg', v:null), hl->get('guibg', v:null)]
    eval hl ->extend(fg isnot# v:null ? #{ guibg: fg } : {})
          \ ->extend(bg isnot# v:null ? #{ guifg: bg } : {})
          \ ->extend(#{ force: v:true })
          \ ->{ hl -> hlset([hl]) }()
  endfunction
endif

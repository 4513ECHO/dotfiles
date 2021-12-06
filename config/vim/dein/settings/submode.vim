let g:submode_always_show_submode = v:true
let g:submode_keep_leaving_key = v:true

" resize window
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" scroll but cursor doesn't move
call submode#enter_with('nomove', 'nx', '', 'zl', 'zl')
call submode#enter_with('nomove', 'nx', '', 'zh', 'zh')
call submode#enter_with('nomove', 'nx', '', 'zL', 'zL')
call submode#enter_with('nomove', 'nx', '', 'zH', 'zH')
call submode#enter_with('nomove', 'nx', '', 'zj', '<C-e>')
call submode#enter_with('nomove', 'nx', '', 'zk', '<C-y>')
call submode#map('nomove', 'nx', '', 'l', 'zl')
call submode#map('nomove', 'nx', '', 'h', 'zh')
call submode#map('nomove', 'nx', '', 'L', 'zL')
call submode#map('nomove', 'nx', '', 'H', 'zH')
call submode#map('nomove', 'nx', '', 'j', '<C-e>')
call submode#map('nomove', 'nx', '', 'k', '<C-y>')

" join x
call submode#enter_with('join-x', 'nx', '', 'x', '"_x')
call submode#map('join-x', 'nx', '', 'x', '<Cmd>undojoin<CR>"_x')
call submode#map('join-x', 'nx', '', 'h', 'h')
call submode#map('join-x', 'nx', '', 'j', 'gj')
call submode#map('join-x', 'nx', '', 'k', 'k')
call submode#map('join-x', 'nx', '', 'l', 'gl')


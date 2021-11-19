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

" scroll horizontal
call submode#enter_with('horizontal', 'nx', '', 'zl', 'zl')
call submode#enter_with('horizontal', 'nx', '', 'zh', 'zh')
call submode#enter_with('horizontal', 'nx', '', 'zL', 'zL')
call submode#enter_with('horizontal', 'nx', '', 'zH', 'zH')
call submode#map('horizontal', 'nx', '', 'l', 'zl')
call submode#map('horizontal', 'nx', '', 'h', 'zh')
call submode#map('horizontal', 'nx', '', 'L', 'zL')
call submode#map('horizontal', 'nx', '', 'H', 'zH')

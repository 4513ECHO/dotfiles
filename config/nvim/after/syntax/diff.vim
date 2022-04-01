" specific comment char (e.g. git core.commentChar)
let s:c = escape((matchstr(getline('$'), '^[#;@!$%^&|:]\S\@!') . '#')[0], '^$.*[]~\"/')
exe 'syn match diffComment "^' .. s:c .. '.*$" '

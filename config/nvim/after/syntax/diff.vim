" specific comment char (e.g. git core.commentChar)
let s:char = (getline('$')->matchstr('^[#;@!$%^&|:]\S\@!') ?? '#')->escape('^$.*[]~\"/')
execute $'syn match diffComment "^{s:char}.*$"'

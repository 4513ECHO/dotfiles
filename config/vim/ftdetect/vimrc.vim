autocmd BufRead,BufNewFile *.grammar,grammar.txt                setfiletype grammar
autocmd BufRead,BufNewFile robots.txt                           setfiletype robots-txt
autocmd BufRead,BufNewFile *[._]curlrc*                         setfiletype curlrc
autocmd BufRead,BufNewFile *[._]gitignore*,*/git/ignore*        setfiletype gitignore
autocmd BufRead,BufNewFile */git/config,.gitconfig_local        setfiletype gitconfig


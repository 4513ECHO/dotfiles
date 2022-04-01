autocmd BufRead,BufNewFile *.grammar,grammar.txt                setfiletype grammar
autocmd BufRead,BufNewFile robots.txt                           setfiletype robots-txt
autocmd BufRead,BufNewFile *[._]curlrc*                         setfiletype curlrc
autocmd BufRead,BufNewFile *[._]gitignore*,*/git/ignore*        setfiletype gitignore
autocmd BufRead,BufNewFile */git/config,.gitconfig[_.]local     setfiletype gitconfig
autocmd BufRead,BufNewFile doc/*.txt                            setfiletype help
autocmd BufRead,BufNewFile doc/*.jax                            setfiletype help
autocmd BufRead,BufNewFile *.lark                               setfiletype lark


autocmd BufRead,BufNewFile *.grammar,grammar.txt                  setfiletype grammar
autocmd BufRead,BufNewFile robots.txt                             setfiletype robots-txt
autocmd BufRead,BufNewFile *[._]curlrc*,[._]curlrc                setfiletype curlrc
autocmd BufRead,BufNewFile */git/ignore,*/git/*ignore*            setfiletype gitignore
autocmd BufRead,BufNewFile [._]gitignore,*[._]gitignore*          setfiletype gitignore
autocmd BufRead,BufNewFile */git/config,.gitconfig[_.]local       setfiletype gitconfig
autocmd BufRead,BufNewFile https://scrapbox.io/api/pages/*/*/text setfiletype scrapbox
autocmd BufRead,BufNewFile queries/*/*.scm                        setfiletype query

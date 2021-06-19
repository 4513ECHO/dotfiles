# viライクな操作を有効にする
bindkey -v

# 自動補完を有効にする
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
setopt auto_cd

# ↑を設定すると、 .. とだけ入力したら1つ上のディレクトリに移動できるので
# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 履歴に残したくないコマンドを入力するとき使う
setopt hist_ignore_space

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# フロンプトの設定
autoload -Uz colors; colors

VIMODE="${fg[cyan]}INSERT${reset_color}"
function zle-keymap-select {
  VI_NORMAL="${fg[green]}NORMAL${reset_color}"
  VI_INSERT="${fg[cyan]}INSERT${reset_color}"
  VIMODE="${${KEYMAP/vicmd/$VI_NORMAL}/(main|viins)/$VI_INSERT}"
  zle reset-prompt
}
zle -N zle-keymap-select

PROMPT="${fg[green]}%n@%m${reset_color}[${VIMODE}]:${fg[blue]}%~${reset_color}%# "

EDITER="vim"

alias c='clear'
alias cdd='cd ~/Develops'
alias cdv='cd ~/.vim'
alias ls='ls -a --color=auto'
alias mk='mkdir'
alias rm='rm -i'
alias vimconf="$EDITER ~/.vimrc"
alias zshconf="$EDITER ~/.zshrc"
alias update="source ~/.zshrc"
alias herokulogin="heroku login --interactive"
alias q="exit"

cd ~/Develops
. ~/Develops/venv/bin/activate

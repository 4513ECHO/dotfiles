# viライクな操作を有効にする
bindkey -v

# 自動補完を有効にする
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
setopt auto_cd

# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# cd した先のディレクトリをディレクトリスタックに追加する
# cd +<Tab> でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space

# <Tab> でパス名の補完候補を表示したあと、続けて <Tab> を押すと候補からパス名を選択できるようになる
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# フロンプトの設定
#VIMODE="${fg[cyan]}INSERT${reset_color}"
#VI_NORMAL="${fg[green]}NORMAL${reset_color}"
#VI_INSERT="${fg[cyan]}INSERT${reset_color}"
#VIMODE="${${KEYMAP/vicmd/$VI_NORMAL}/(main|viins)/$VI_INSERT}"
#PROMPT="${fg[green]}%n@%m${reset_color}[${VIMODE}]:${fg[blue]}%~${reset_color} %#"

autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
  print -rn -- $terminfo[el]
}
add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish
{
  case $KEYMAP in
    main|viins)
    PROMPT_2="$fg[cyan]-- INSERT --$reset_color"
    ;;
  vicmd)
    PROMPT_2="${fg[green]}-- NORMAL --$reset_color"
    ;;
  vivis|vivli)
    PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
    ;;
  esac

  PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})%n%{${reset_color}%}]%# "
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

EDITER="vim"

# 各種エイリアスの設定
alias c='clear'
alias cdd='cd ~/Develops'
alias cdv='cd ~/.vim'
alias ls='ls -a --color=auto'
alias rm='rm -i'
alias vimconf="$EDITER ~/.vimrc"
alias zshconf="$EDITER ~/.zshrc"
alias update="source ~/.zshrc"
alias herokulogin="heroku login --interactive"
alias q="exit"

# ターミナル起動時に自動で仮想環境を起動する
cd ~/Develops
. ~/Develops/venv/bin/activate

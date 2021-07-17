# viライクな操作を有効にする
bindkey -v

# 自動補完を有効にする
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
setopt auto_cd

# cd した先のディレクトリをディレクトリスタックに追加する
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

# 単語の一部として扱われる文字のセット
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# フロンプトの設定
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=${terminfo[cud1]}${terminfo[cuu1]}${terminfo[sc]}${terminfo[cud1]}
function left_down_prompt_preexec () {
  print -rn -- ${terminfo[el]}
}
add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish {
  case $KEYMAP in
    main|viins)
    PROMPT_2="${fg[cyan]}-- INSERT --${reset_color}"
    ;;
  vicmd)
    PROMPT_2="${fg[white]}-- NORMAL --${reset_color}"
    ;;
  vivis|vivli)
    PROMPT_2="${fg[yellow]}-- VISUAL --${reset_color}"
    ;;
  esac

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

function git-prompt () {
  local branchname branch st remote pushed upstream

  branchname=`git symbolic-ref --short HEAD 2> /dev/null`
  if [ -z $branchname ]; then
    return
  fi
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"`  ]]; then
    branch="%{${fg[green]}%}($branchname)%{$reset_color%}"
  elif [[ -n `echo "$st" | grep "^nothing added"`  ]]; then
    branch="%{${fg[yellow]}%}($branchname)%{$reset_color%}"
  else
    branch="%{${fg[red]}%}($branchname)%{$reset_color%}"
  fi

  remote=`git config branch.${branchname}.remote 2> /dev/null`
  if [ -z $remote  ]; then
    pushed=''
  else
    upstream="${remote}/${branchname}"
    if [[ -z `git log ${upstream}..${branchname}`  ]]; then
      pushed="%{${fg[green]}%}[up]%{$reset_color%}"
    else
      pushed="%{${fg[red]}%}[up]%{$reset_color%}"
    fi
  fi

  echo "$branch$pushed"
}

PROMPT="%{$terminfo_down_sc$PROMPT_2${terminfo[rc]}%}${fg[green]}%n@%m${reset_color}:${fg[blue]}%~${reset_color} %# "
RPROMPT="`git-prompt`"

EDITOR="vim"

alias c="clear"
alias cdd="cd ~/Develops"
alias ls="ls -a --color=auto"
alias rm="rm -i"
alias vimconf="$EDITOR ~/.vimrc"
alias zshconf="$EDITOR ~/.zshrc"
alias update="source ~/.zshrc"
alias herokulogin="heroku login --interactive"
alias q="exit"
alias gcm="git commit -m"
alias ...="cd ../.."
alias ....="cd ../../.."

# venvの設定
if [ -n "${VIRTUAL_ENV}" ]; then
PROMPT="(`basename \"${VIRTUAL_ENV}\"`)${PROMRT}"
fi

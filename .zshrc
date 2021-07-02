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
    PROMPT_2="${fg[white]}-- NORMAL --$reset_color"
    ;;
  vivis|vivli)
    PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
    ;;
  esac

  PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}${fg[green]}%n@%m${reset_color}:${fg[blue]}%~${reset_color} %# "
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

# gitのブランチを色付きで表示させる
function rprompt-git-current-branch {
  local branch_name st branch_status

    if [ ! -e  ".git"  ]; then
      # git 管理されていないディレクトリは何も返さない
      return
    fi
    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"`  ]]; then
# 全て commit されてクリーンな状態
      branch_status="%F{green}"
    elif [[ -n `echo "$st" | grep "^Untracked files"`  ]]; then
# git 管理されていないファイルがある状態
      branch_status="%F{red}?"
    elif [[ -n `echo "$st" | grep "^Changes not staged for commit"`  ]]; then
# git add されていないファイルがある状態
      branch_status="%F{red}+"
    elif [[ -n `echo "$st" | grep "^Changes to be committed"`  ]]; then
# git commit されていないファイルがある状態
      branch_status="%F{yellow}!"
    elif [[ -n `echo "$st" | grep "^rebase in progress"`  ]]; then
# コンフリクトが起こった状態
      echo "%F{red}!(no branch)"
      return
    else
# 上記以外の状態の場合
      branch_status="%F{blue}"
    fi
# ブランチ名を色付きで表示する
    echo "${branch_status}[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'


EDITOR="vim"

# 各種エイリアスの設定
alias c='clear'
alias cdd='cd ~/Develops'
alias cdv='cd ~/.vim'
alias ls='ls -a --color=auto'
alias rm='rm -i'
alias vimconf="$EDITOR ~/.vimrc"
alias zshconf="$EDITOR ~/.zshrc"
alias update="source ~/.zshrc"
alias herokulogin="heroku login --interactive"
alias q="exit"
alias gcm="git commit -m"

# venvの設定
if [ -n "${VIRTUAL_ENV}" ]; then
  . ${VIRTUAL_ENV}/bin/activate
  PROMPT="(`basename \"${VIRTUAL_ENV}\"`)${PROMRT}"
fi

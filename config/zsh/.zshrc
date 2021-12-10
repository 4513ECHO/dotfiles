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

setopt no_beep

zstyle ':completion:*:default' menu select=2
setopt auto_menu
setopt auto_param_keys

bindkey -e
autoload -Uz add-zsh-hook

if [[ -f ~/.minimum_dotfiles ]]; then
  export MINIMUM_DOTFILES=true
fi

() {
  for rc in $ZDOTDIR/*.zsh; do
    source "$rc"
  done
}

() {
  autoload -Uz compinit
  : ${ZSH_COMPDUMP:=$XDG_CACHE_HOME/zsh/compdump-$(hostname)-$ZSH_VERSION}
  local dump=$ZSH_COMPDUMP
  local dumpc=${dump}.zwc
  # re-check dump file that are older than 24 hours
  if [[ -n $dump(#qN.mh+24) ]]; then
    compinit -i -d "$dump"
    { rm -rf "$dumpc" && zcompile "$dump" } &!
  else
    compinit -C -d "$dump"
    { [[ ! -s $dumpc || $dump -nt $dumpc ]] && rm -rf "$dumpc" && zcompile "$dump" } &!
  fi
  for f in $(find $ZDOTDIR/ -type f -name '*.zsh') $ZDOTDIR/.zshrc; do
    if [[ ! -f "$f.zwc" ]] || [[ "$f" -nt "$f.zwc" ]]; then
      { zcompile "$f" } &!
    fi
  done
}

export LOADED_ZSHRC=true

if type zprof > /dev/null; then
  zprof | vim -
fi

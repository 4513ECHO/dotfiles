bindkey -v

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

zstyle ':completion:*:default' menu select=2
setopt auto_menu
setopt auto_param_keys

export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --marker='*' --select-1 --exit-0"

for rc in $ZDOTDIR/*.zsh; do
  source "$rc"
done

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

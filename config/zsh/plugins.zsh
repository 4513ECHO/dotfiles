[[ -n "$MINIMUM_DOTFILES" ]] && return

exists() {
  if (( $+commands[$@] )); then
    return 0
  else
    return 1
  fi
}

[[ $- == *l* ]] || return

if [[ ! -f "$XDG_CACHE_HOME/zpm/zpm.zsh" ]]; then
  git clone --recursive --depth 1 'https://github.com/zpm-zsh/zpm' \
    "$XDG_CACHE_HOME/zpm"
fi
source "$XDG_CACHE_HOME/zpm/zpm.zsh"

zpm load zsh-users/zsh-autosuggestions,source:/zsh-autosuggestions.zsh,async
zpm load zdharma-continuum/fast-syntax-highlighting,async
zpm load zsh-users/zsh-completions,apply:fpath,fpath:/src,async
# zpm load 4513ECHO/zsh-sticky-shift,async; STICKY_TABLE='jis'
# zpm load junegunn/fzf,source:/shell/key-bindings.zsh,source:/shell/completion.zsh,async
# zpm load junegunn/fzf,source:/shell/completion.zsh,async
zpm load junegunn/fzf,source:/shell/key-bindings.zsh,async
# zpm load iwata/git-now,apply:path,hook:"make prefix=./ install"
exists deno && zpm load @exec/deno,destination:completion,origin:'deno completions zsh'
exists rustup && zpm load @exec/rustup,destination:completion,origin:'rustup completions zsh'
exists cargo && zpm load @exec/cargo,destination:completion,origin:'rustup completions zsh cargo'
exists npm && zpm load @exec/npm,destination:completion,origin:'npm completion'
exists gh && zpm load @exec/gh,destination:completion,origin:'gh completion -s zsh'
exists pip && zpm load @exec/pip,origin:'pip completion --zsh'
exists poetry && zpm load @exec/poetry,destination:completion,origin:'poetry completions zsh'
exists sbx && zpm load @exec/sbx,destination:completion,origin:'sbx completion zsh'
exists hgrep && zpm load @exec/hgrep,destination:completion,origin:'hgrep --generate-completion-script zsh'
exists afx && zpm load @exec/afx,destination:completion,origin:'afx completion zsh'
exists aqua && zpm load @exec/aqua,origin:'aqua completion zsh'
zpm load @exec/git,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/git/git/contrib/completion/git-completion.zsh'
zpm load @exec/fd,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/sharkdp/fd/contrib/completion/_fd'
zpm load @exec/rg,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/BurntSushi/ripgrep/complete/_rg'
zpm load @exec/exa,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/ogham/exa/completions/zsh/_exa'
zpm load @exec/ghq,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/x-motemen/ghq/misc/zsh/_ghq'
zpm load @exec/gojq,destination:completion,origin:'curl -qfsSL https://pax.deno.dev/itchyny/gojq/_gojq'

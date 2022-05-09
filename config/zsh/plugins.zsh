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
exists deno && zpm load @empty/deno,gen-completion:'deno completions zsh'
exists rustup && zpm load @empty/rustup,gen-completion:'rustup completions zsh'
exists cargo && zpm load @empty/cargo,gen-completion:'rustup completions zsh cargo'
exists npm && zpm load @empty/npm,gen-plugin:'npm completion'
exists gh && zpm load @empty/gh,gen-completion:'gh completion -s zsh'
exists pip && zpm load @empty/pip,gen-plugin:'pip completion --zsh'
exists poetry && zpm load @empty/poetry,gen-completion:'poetry completions zsh'
exists sbx && zpm load @empty/sbx,gen-completion:'sbx completion zsh'
exists hgrep && zpm load @empty/hgrep,gen-completion:'%❯ hgrep --generate-completion-script zsh'
# exists pipx && zpm load @empty/pipx,gen-plugin:'register-python-argcomplete3 pipx'
zpm load @empty/git,gen-completion:'curl -qfsSL https://pax.deno.dev/git/git/contrib/completion/git-completion.zsh'
zpm load @empty/fd,gen-completion:'curl -qfsSL https://pax.deno.dev/sharkdp/fd/contrib/completion/_fd'
zpm load @empty/rg,gen-completion:'curl -qfsSL https://pax.deno.dev/BurntSushi/ripgrep/complete/_rg'
zpm load @empty/exa,gen-completion:'curl -qfsSL https://pax.deno.dev/ogham/exa/completions/zsh/_exa'
zpm load @empty/ghq,gen-completion:'curl -qfsSL https://pax.deno.dev/x-motemen/ghq/misc/zsh/_ghq'
zpm load @empty/gojq,gen-completion:'curl -qfsSL https://pax.deno.dev/itchyny/gojq/_gojq'

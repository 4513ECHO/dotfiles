DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CONFIGHOME := $(wildcard $(realpath $(DOTPATH)/config)/*)
DOTRC := $(wildcard $(realpath $(DOTPATH)/dotrc)/.??*)
BINFILE := $(wildcard $(realpath $(DOTPATH)/bin)/*)
RM := rm -fv
LN := ln -sfnv

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show targets in this Makefile
ifeq ($(TARGET),)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo 'Please `$(MAKE) help TARGET=<target>` to see more detail of each of the targets.'
else
	@awk -v TARGET=$(TARGET) \
	  'BEGIN {found = 0}; /^[^\t#]|^$$/ {found = $$1 == TARGET ":" || (found && $$1 ~ /^(if|else|endif)/)}; found' \
	  $(MAKEFILE_LIST)
endif

.PHONY: init
init: ## Initialize enviroment settings
	@mkdir -pv ~/.config
	@mkdir -pv ~/.local/bin
	@mkdir -pv ~/.local/share
	@mkdir -pv ~/.cache
	@mkdir -pv ~/Develops

.PHONY: deploy
deploy: ## Create symlinks to actual directories
	@$(foreach val, $(DOTRC), $(LN) $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGHOME), $(LN) $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)
	@$(foreach val, $(BINFILE), $(LN) $(abspath $(val)) $(HOME)/.local/bin/$(notdir $(val));)
	@$(LN) $(realpath $(DOTPATH)/config)/zsh/.zshenv $(HOME)/.zshenv

.PHONY: update
update: ## Fetch and merge all changes from remote repository
	git fetch origin
	git rebase --autostash --stat FETCH_HEAD

.PHONY: install
install: update init deploy ## Initialize and deploy dotfiles
	@exec "$$SHELL" -l

.PHONY: clean
clean: ## Remove symlinks from actual directories
	@$(foreach val, $(DOTRC), test -f $(HOME)/$(notdir $(val)) && $(RM) $(HOME)/$(notdir $(val)) ||:;)
	@$(foreach val, $(CONFIGHOME), test -f $(HOME)/.config/$(notdir $(val)) && $(RM) $(HOME)/.config/$(notdir $(val)) ||:;)
	@$(foreach val, $(BINFILE), test -f $(HOME)/.local/bin/$(notdir $(val)) && $(RM) $(HOME)/.local/bin/$(notdir $(val)) ||:;)
	@$(RM) $(HOME)/.zshenv

.PHONY: pipx
pipx: ## Install and initialize pipx enviroments
	python3 -m venv $(XDG_DATA_HOME)/pipx
	$(XDG_DATA_HOME)/pipx/bin/python -m pip install pipx
	@$(LN) $(XDG_DATA_HOME)/pipx/bin/pipx $(HOME)/.local/bin

.PHONY: aqua
aqua: ## Install and initialize aqua enviroments
	curl -fsSL https://pax.deno.dev/aquaproj/aqua-installer@v1.0.0/aqua-installer | bash
	aqua install --test

.PHONY: rust
rust: ## Install and initialize rust enviroments
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup update nightly
	rustup default nightly

.PHONY: go
go: ## Install and initialize golang enviroments
	case "$(shell uname -m)" in \
	  i386) GOARCH="386" ;; \
	  i686|x86_64) GOARCH="amd64" ;; \
	  arm|armv7l|armv6l) GOARCH="arm" ;; \
	  aarch64|armv8b|armv8l) GOARCH="arm64" ;; \
	  mips) GOARCH="mips" ;; \
	  mips64) GOARCH="mips64" ;; \
	  ppc|ppc64) GOARCH="ppc64" ;; \
	  ppc64le|ppcle) GOARCH="ppc64le" ;; \
	  s390|s390x) GOARCH="s390x" ;; \
	esac; \
	case "$(shell uname -s)" in \
	  AIX) GOOS="aix" ;; \
	  Darwin) GOOS="darwin" ;; \
	  DragonFly) GOOS="dragonfly" ;; \
	  FreeBSD) GOOS="freebsd" ;; \
	  Linux) GOOS="linux" ;; \
	  OpenBSD) GOOS="openbsd" ;; \
	  NetBSD) GOOS="netbsd" ;; \
	  SunOS) GOOS="solaris" ;; \
	  CYGWIN|*[Ww]indows*) GOOS="windows" ;; \
	esac; \
	GOVERSION="$(shell curl -qfsSL https://go.dev/VERSION?m=text)"; \
	curl -fsSLO https://golang.org/dl/$${GOVERSION}.$${GOOS}-$${GOARCH}.tar.gz
	tar -C $(XDG_DATA_HOME) -xzf go*.tar.gz
	@$(RM) go*.tar.gz

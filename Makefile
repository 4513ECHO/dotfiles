export
DOTPATH ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_STATE_HOME ?= $(HOME)/.local/state

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show targets in this Makefile
ifeq ($(TARGET),)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[m %s\n", $$1, $$2}'
	@echo 'Please run `$(MAKE) help TARGET=<target>` to see more detail of each of the targets.'
else
	@awk -v TARGET=$(TARGET) \
	  'BEGIN {found = 0}; /^[^\t#]|^$$/ {found = $$1 == TARGET ":" || (found && $$1 ~ /^(if|else|endif)/)}; found' \
	  $(MAKEFILE_LIST)
endif

.PHONY: init
init: ## Initialize enviroment settings
	mkdir -p $(XDG_CONFIG_HOME)
	mkdir -p $(XDG_CACHE_HOME)
	mkdir -p $(XDG_STATE_HOME)
	mkdir -p $(XDG_DATA_HOME)
	mkdir -p $(HOME)/.local/bin
	mkdir -p $(HOME)/Develops

.PHONY: deploy
deploy: ## Create symlinks to actual directories
	@echo 'Deploying dotfiles...'
	@$(DOTPATH)/scripts/link.sh link

.PHONY: update
update: ## Fetch and rebase all changes from remote repository
	@echo 'Updating dotfiles...'
ifneq ($(shell git rev-parse --abbrev-ref HEAD),main)
ifneq ($(FETCH_FROM_MAIN),)
	git stash
	git switch -m main
endif
endif
	git fetch origin
	git rebase --autostash --stat FETCH_HEAD
ifneq ($(shell git rev-parse --abbrev-ref HEAD),main)
ifneq ($(FETCH_FROM_MAIN),)
	git switch -m -
	git stash pop
	git rebase --autostash --stat main
endif
endif

.PHONY: install
install: update init deploy ## Initialize and deploy dotfiles
	@echo 'Please run `exec $$SHELL -l` to reload shell.'

.PHONY: clean
clean: ## Remove symlinks from actual directories
	@echo 'Cleaning dotfiles...'
	@$(DOTPATH)/scripts/link.sh unlink

.PHONY: aqua
aqua: ## Install and initialize aqua enviroments
ifeq ($(shell command -v aqua),)
	curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.4/aqua-installer | bash -s -- -v v2.56.5
else
	aqua update-aqua
endif
	$${AQUA_ROOT_DIR:-$$XDG_DATA_HOME/aquaproj-aqua}/bin/aqua install --all

.PHONY: rust
rust: ## Install and initialize rust enviroments
ifeq ($(shell command -v rustup),)
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup toolchain install nightly
	rustup default nightly
	rustsp target add wasm32-wasip2
	rustup component add rust-analyzer
else
	rustup update nightly
endif

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
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo 'Please `$(MAKE) help TARGET=<target>` to see more detail of each of the targets.'
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
	@$(DOTPATH)/scripts/link.sh link

.PHONY: update
update: ## Fetch and merge all changes from remote repository
	git fetch origin
	git rebase --autostash --stat FETCH_HEAD

.PHONY: install
install: update init deploy ## Initialize and deploy dotfiles
	exec "$$SHELL" -l

.PHONY: clean
clean: ## Remove symlinks from actual directories
	@$(DOTPATH)/scripts/link.sh unlink

.PHONY: python
python: ## Install and initialize python enviroments
	python3 -m venv $(XDG_DATA_HOME)/poetry
	$(XDG_DATA_HOME)/poetry/bin/python -m pip install poetry
	cd $(XDG_CONFIG_HOME)/python; \
	$(XDG_DATA_HOME)/poetry/bin/poetry install

.PHONY: aqua
aqua: ## Install and initialize aqua enviroments
	curl -fsSL https://pax.deno.dev/aquaproj/aqua-installer@v2.0.2/aqua-installer | bash -s -- -v v1.38.0
	export PATH="$${AQUA_ROOT_DIR:-$$XDG_DATA_HOME/aquaproj-aqua/bin}:$$PATH"
	aqua install --all --test

.PHONY: rust
rust: ## Install and initialize rust enviroments
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup update nightly
	rustup default nightly

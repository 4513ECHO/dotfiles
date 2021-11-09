DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CONFIGHOME := $(wildcard $(realpath $(DOTPATH)/config)/*)
DOTRC := $(wildcard $(realpath $(DOTPATH)/dotrc)/.??*)
BINFILE := $(wildcard $(realpath $(DOTPATH)/bin)/*)

.DEFAULT_GOAL := help
.PHONY := help init deploy update install clean destroy

all:

help:
	@echo "make help"
	@echo "help: show this message"
	@echo "init: "

init:
	@/bin/sh -c  $(DOTPATH)/etc/init.sh

deploy:
	@$(foreach val, $(DOTRC), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGHOME), ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)
	@$(foreach val, $(BINFILE), ln -sfnv $(abspath $(val)) $(HOME)/.local/bin/$(notdir $(val));)

update:
	git pull origin main

install: update init deploy

clean:
	@$(foreach val, $(DOTRC), test -f $(HOME)/$(notdir $(val)) && rm -v $(HOME)/$(notdir $(val)) ||:;)
	@$(foreach val, $(CONFIGHOME), test -f $(HOME)/.config/$(notdir $(val)) && rm -v $(HOME)/.config/$(notdir $(val)) ||:;)
	@$(foreach val, $(BINFILE), test -f $(HOME)/.local/bin/$(notdir $(val)) && rm -v $(HOME)/.local/bin/$(notdir $(val)) ||:;)

destroy: clean
	@rm -r $(DOTPATH)
	@rm -r $(HOME)/.cache/*
	@rm -r $(HOME)/.local/share/*

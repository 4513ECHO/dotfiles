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
	@echo "make init"
	@/bin/sh -c  $(DOTPATH)/bin/init.sh

deploy:
	@echo "make deploy"
	@$(foreach val, $(DOTRC), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGHOME), ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)
	@$(foreach val, $(BINFILE), ln -sfnv $(abspath $(val)) $(HOME)/.local/bin/$(notdir $(val));)

update:
	@echo "make update"
	git pull origin main

install: update init deploy

clean:
	@echo "make clean"
	@$(foreach val, $(DOTRC), rm -v $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGHOME), rm -v $(HOME)/.config/$(notdir $(val));)
	@$(foreach val, $(BINFILE), rm -v $(HOME)/.local/bin/$(notdir $(val));)

destroy: clean
	@rm -r $(DOTPATH)
	@rm -r $(HOME)/.cache/*

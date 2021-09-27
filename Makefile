DOTPATH := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CONFIGHOME := $(wildcard $(realpath $(DOTPATH)/config)/*)
DOTRC := $(wildcard $(realpath $(DOTPATH)/dotrc)/.??*)

.DEFAULT_GOAL := help
.PHONY := help init deploy update install clean destroy

all:

help:
	@echo "help!"

init:
	@echo "init!"

deploy:
	@$(foreach val, $(DOTRC), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGHOME), ln -sfnv $(abspath $(val)) $(HOME)/.config/$(notdir $(val));)

update:
	git fetch origin main

install: update deploy init

clean:
	@$(foreach val, $(DOTRC), rm $(HOME)/$(val))
	@$(foreach val, $(DOTCONFIG), rm $(HOME)/.config/$(val))

destroy: clean
	@rm -rf $(DOTPATH)
	@rm -rf $(HOME)/.cache/*

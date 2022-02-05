# dotfiles

☸ My configration files

## Feature

- vim
  - [dein.vim](https://github.com/Shougo/dein.vim)
  - [many colorschemes](./config/vim/dein/colorscheme.toml)
  - [ddc.vim](https://github.com/Shougo/ddc.vim)
- zsh
  - [zinit](https://github.com/)
- tmux

## Installation

```sh
git clone https://github.com/4513ECHO/dotfiles.git
cd dotfiles
make install
```

## File tree

```
.
├── bin
│  ├── colortable
│  └── pathshorten
├── config
│  ├── efm-langserver
│  │  └── config.yaml
│  ├── git
│  │  ├── commit_template
│  │  ├── config
│  │  └── ignore
│  ├── tmux
│  │  └── tmux.conf
│  ├── vim
│  │  ├── after
│  │  │  ├── ftplugin
│  │  │  │  └── help.vim
│  │  │  └── syntax
│  │  │     ├── diff.vim
│  │  │     ├── python.vim
│  │  │     └── vim.vim
│  │  ├── autoload
│  │  │  ├── user
│  │  │  │  ├── colorscheme.vim
│  │  │  │  ├── ddc.vim
│  │  │  │  └── lightline.vim
│  │  │  ├── lightsout.vim
│  │  │  └── user.vim
│  │  ├── colors
│  │  │  └── .gitkeep
│  │  ├── dein
│  │  │  ├── settings
│  │  │  │  ├── ddc.vim
│  │  │  │  ├── lexima.vim
│  │  │  │  ├── lightline.vim
│  │  │  │  ├── skkeleton.vim
│  │  │  │  ├── submode.vim
│  │  │  │  ├── vim-lsp-settings.json
│  │  │  │  └── vim-lsp.vim
│  │  │  ├── colorscheme.toml
│  │  │  ├── ddc.toml
│  │  │  ├── ftplugin.toml
│  │  │  ├── init.toml
│  │  │  ├── plugin.toml
│  │  │  └── textobj.toml
│  │  ├── ftdetect
│  │  │  └── vimrc.vim
│  │  ├── rc
│  │  │  ├── 000_init.rc.vim
│  │  │  ├── 100_dein.rc.vim
│  │  │  ├── 200_keymap.rc.vim
│  │  │  └── 300_options.rc.vim
│  │  ├── syntax
│  │  │  ├── curlrc.vim
│  │  │  ├── gitignore.vim
│  │  │  ├── grammar.vim
│  │  │  └── robots-txt.vim
│  │  └── vimrc
│  └── zsh
│      ├── .zshrc
│      ├── aliases.zsh
│      ├── completion.zsh
│      ├── functions.zsh
│      ├── option.zsh
│      ├── plugins.zsh
│      └── prompt.zsh
├── dotrc
│  ├── .bashrc
│  ├── .curlrc
│  └── .zshenv
├── etc
│  └── init.sh
├── .gitignore
├── LICENSE.md
├── Makefile
└── README.md
```

# dotfiles

> ⚙ My configuration files and personal preferences

<!--ts-->
* [dotfiles](#dotfiles)
   * [Features](#-features)
   * [Installation](#-installation)
      * [Quick Start](#quick-start)
      * [Manually install](#manually-install)
   * [Requirements](#-requirements)
      * [tmux](#tmux)
      * [vim / neovim](#vim--neovim)
      * [zsh](#zsh)
<!--te-->

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## 🎨 Features

- [tmux](./config/tmux)
- [vim](./config/vim)
  - [dein.vim](https://github.com/Shougo/dein.vim)
  - [many random colorschemes](./config/vim/dein/colorscheme.toml)
  - [ddc.vim](https://github.com/Shougo/ddc.vim)
  - [ddu.vim](https://github.com/Shougo/ddu.vim)
- [zsh](./config/zsh)

## ✨ Installation

### Quick Start

You can use [pax.deno.dev](https://github.com/kawarimidoll/pax.deno.dev) to
abbreviate the URL.

```sh
curl -L pax.deno.dev/4513ECHO/dotfiles/up | sh
```

### Manually install

```sh
git clone --depth 1 https://github.com/4513ECHO/dotfiles
cd dotfiles
make install
```

## 📦 Requirements

Other executable binaries or plugins will be installed automatically.

### tmux

[tmux](https://github.com/tmux/tmux) muse be 3.1c or later.
lastest version is recommended.

### vim / neovim

**HEAD is recommended.**
[vim](https://github.com/vim/vim) must be 8.2.3452 or later.
[neovim](https://github.com/neovim/neovim) must be 0.6.1 or later.

### zsh

zsh should be 5.8 or later.


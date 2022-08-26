# ![dotfiles](https://user-images.githubusercontent.com/81011153/180718947-cb2428f2-0f54-46a1-93c6-d54ad206c6a8.jpeg)

> ⚙ My configuration files and personal preferences

![last commit](https://img.shields.io/github/last-commit/4513ECHO/dotfiles)
![license](https://img.shields.io/github/license/4513ECHO/dotfiles)
![code size](https://img.shields.io/github/languages/code-size/4513ECHO/dotfiles)
![repo stars](https://img.shields.io/github/stars/4513ECHO/dotfiles)

---

Table of Contents

<!--ts-->
   * [Features](#-features)
      * [aqua](#aqua)
      * [tmux](#tmux)
      * [vim / neovim](#vim--neovim)
      * [zsh](#zsh)
   * [Installation](#-installation)
      * [Quick Start](#quick-start)
      * [Manually install](#manually-install)
   * [Requirements](#-requirements)
   * [Acknowledgements](#-acknowledgements)
   * [Statistics](#-statistics)
      * [Code Lengths](#code-lengths)
      * [Vim Plugins](#vim-plugins)
<!--te-->

TOC is created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc).

---

## 🎨 Features

### aqua

[aqua](https://aquaproj.github.io) is declarative CLI Version manager written in
Go. Support Lazy Install, Registry, and continuous update with Renovate. CLI
version is switched seamlessly.

The configuration files are [here](./config/aqua).

- [Test](./.github/workflows/aqua.yaml) with GitHub Action
- My experimental [registry](./config/aqua/experimental.yaml)

You can use my experimental registry through your `aqua.yaml`.

```yaml
registries:
  - name: experimental
    type: github_content
    repo_owner: 4513ECHO
    repo_name: dotfiles
    ref: <some commit hash>
    path: config/aqua/experimental.yaml
```

Please read
[aqua's documentation](https://aquaproj.github.io/docs/reference/config/#github_content-registry)
for detail.

Packages in my registry are sometimes removed without notice when standard
registry includes it.

### tmux

The configuration files are [here](./config/tmux).

- Plugins managed by [tpm](https://github.com/tmux-plugins/tpm)

### vim / neovim

The configuration files are [here](./config/nvim).

- **Works well with both vim and neovim**
- Plugins managed by [dein.vim](https://github.com/Shougo/dein.vim)
- Colorful and random [colorschemes](./config/nvim/dein/colorscheme.toml)
- Dark powered completion with [ddc.vim](https://github.com/Shougo/ddc.vim)
- Fuzzy finder with [ddu.vim](https://github.com/Shougo/ddu.vim) and
  [fzf.vim](https://github.com/junegunn/fzf.vim)

You can use this dotfiles as plugin like below:

```vim
call dein#add('4513ECHO/dotfiles', {'rtp': 'config/nvim'})
```

The configuration does not have `plugin/` directory, so it does not define any
mappings or commands by default. You can use autoload function, lua function,
toml files for dein and so on.

### zsh

The configuration files are [here](./config/zsh).

- Plugins managed by [zpm](https://github.com/zpm-zsh/zpm)

## ✨ Installation

### Quick Start

You only have to fetch setup script from following URL. `-L` option is needed to
follow redirect.

```sh
curl -L https://4513echo.deno.dev/dot | sh
```

### Manually install

```sh
git clone --depth 1 https://github.com/4513ECHO/dotfiles
cd dotfiles
make install
```

## 📦 Requirements

Other executable binaries or plugins will be installed automatically by
[aqua](#aqua).

- [curl](https://curl.se)
- [git](https://git-scm.com)
- [tmux](https://github.com/tmux/tmux)

tmux must be `3.1c` or later. Latest version is recommended.

- [vim](https://github.com/vim/vim) / [neovim](https://github.com/neovim/neovim)

**HEAD is recommended.**

vim must be `v8.2.3520` (toml syntax is included in runtime by default) or
later. neovim must be `v0.8.0` (after `ca64b589c`, filetype.lua is enabled by
default) or later.

- zsh

## 💞 Acknowledgements

My dotfiles are heavy inspired by
[these dotfiles](https://github.com/stars/4513ECHO/lists/dotfiles) and other
many articles on the Internet. Thanks a lot!

## 📊 Statistics

<!--deno-fmt-ignore-->
Statistics are updated at [`52302ac`](https://github.com/4513ECHO/dotfiles/commit/52302ac3e1bb78ca442fdfeb5908b8cc8fa19ed8).

### Code Lengths

It uses [tokei](https://github.com/XAMPPRocky/tokei) to measure.

<!--tokei-start-->
```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 BASH                   18          280          188           43           49
 JSON                   12         1305         1305            0            0
 Lua                     7          318          241           42           35
 Makefile                1           98           87            0           11
 Python                  1           33           22            3            8
 Scheme                  6          106           84           11           11
 Shell                   8          177          142           19           16
 Plain Text              1           35            0           24           11
 TOML                   11         2476         2181           31          264
 TypeScript              5          227          200            5           22
 Vim script             27         1916         1752           50          114
 YAML                    7          583          498           37           48
 Zsh                     6          537          411           85           41
-------------------------------------------------------------------------------
 Markdown                2          192            0          134           58
 |- YAML                 1            7            7            0            0
 (Total)                            199            7          134           58
===============================================================================
 Total                 112         8283         7111          484          688
===============================================================================
```
<!--tokei-end-->

### Vim Plugins

<!--vim-plugins-start-->
```
colorscheme.toml      60
ddc.toml              22
ddu.toml              32
ftplugin.toml         13
init.toml             17
neovim.toml            8
plugin.toml           50
textobj.toml          11
unused.toml           20
vim.toml               9
------------------------
total(vim)           214
total(neovim)        213
```
<!--vim-plugins-end-->

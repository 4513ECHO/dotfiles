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

- Quick copying with [tmux-thumbs](https://github.com/fcsonline/tmux-thumbs)

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
git clone --depth=1 --filter=blob:none https://github.com/4513ECHO/dotfiles
cd dotfiles
make install
```

## 📦 Requirements

Other executable binaries or plugins will be installed automatically by
[aqua](#aqua).

- [curl](https://curl.se)
- make
- [git](https://git-scm.com)
- [tmux](https://github.com/tmux/tmux): `3.2a` or later
- [vim](https://github.com/vim/vim) / [neovim](https://github.com/neovim/neovim)
- zsh

Latest versions are recommended.

vim must be `v9.0.1000` or later. neovim must be `v0.9.0` or later. For both of
vim and neovim, **HEAD is recommended.**

## 💞 Acknowledgements

My dotfiles are heavy inspired by
[these dotfiles](https://github.com/stars/4513ECHO/lists/dotfiles) and other
many articles on the Internet. Thanks a lot!

## 📊 Statistics

<!--deno-fmt-ignore-->
Statistics are updated at [`cbe8330`](https://github.com/4513ECHO/dotfiles/commit/cbe83308d2dbb8c3bb82fe5a2f6f89365405d5dd).

### Code Lengths

It uses [tokei](https://github.com/XAMPPRocky/tokei) to measure.

<!--tokei-start-->
```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 BASH                   18          285          192           43           50
 INI                     1            2            2            0            0
 JSON                   15         1305         1305            0            0
 Lua                     3          152           85           41           26
 Makefile                1           71           61            0           10
 Python                  1           33           22            3            8
 Scheme                  6          141          119           10           12
 Shell                   9          179          130           29           20
 Plain Text              3          187            0          142           45
 TOML                   13         2624         2302           46          276
 TypeScript              5          248          222            4           22
 Vim script             26         1779         1650           45           84
 YAML                    9          721          632           41           48
 Zsh                     6          535          402           92           41
-------------------------------------------------------------------------------
 Markdown                2          188            0          133           55
 |- YAML                 1            7            7            0            0
 (Total)                            195            7          133           55
===============================================================================
 Total                 118         8450         7124          629          697
===============================================================================
```
<!--tokei-end-->

### Vim Plugins

<!--vim-plugins-start-->
```
colorscheme.toml      60
ddc.toml              22
ddu.toml              28
ftplugin.toml         13
init.toml             10
neovim.toml            7
plugin.toml           55
textobj.toml          10
unused.toml           24
vim.toml               9
------------------------
total(vim)           207
total(neovim)        205
```
<!--vim-plugins-end-->

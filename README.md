# dotfiles

> ⚙ My configuration files and personal preferences

---

## Table of Contents

<!--ts-->
* [dotfiles](#dotfiles)
   * [Table of Contents](#table-of-contents)
   * [Features](#-features)
      * [tmux](#tmux)
      * [Vim / Neovim](#vim--neovim)
      * [Zsh](#zsh)
   * [Installation](#-installation)
      * [Quick Start](#quick-start)
      * [Manually install](#manually-install)
   * [Requirements](#-requirements)
      * [git](#git)
      * [tmux](#tmux-1)
      * [Vim / Neovim](#vim--neovim-1)
      * [Zsh](#zsh-1)
   * [Acknowledgements](#-acknowledgements)
   * [Statistics](#-statistics)
      * [Code Lens](#code-lens)
      * [(Neo)vim Startup Time](#neovim-startup-time)
<!--te-->

TOC is created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc).

---

## 🎨 Features

### tmux

The configuration files are [here](./config/tmux).

- Plugins managed by [tpm](https://github.com/tmux-plugins/tpm)

### Vim / Neovim

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

### Zsh

The configuration files are [here](./config/zsh).

- Plugins managed by [zpm](https://github.com/zpm-zsh/zpm)

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

### git

### tmux

[tmux](https://github.com/tmux/tmux) muse be `3.1c` or later. Latest version is
recommended.

### Vim / Neovim

**HEAD is recommended.**

[Vim](https://github.com/vim/vim) must be `v8.2.3520` (toml syntax is included
in runtime by default) or later. [Neovim](https://github.com/neovim/neovim) must
be `v0.7.0` or later.

### Zsh

## 💞 Acknowledgements

My dotfiles are heavy inspired by
[these dotfiles](https://github.com/stars/4513ECHO/lists/dotfiles) and other
many articles on the Internet. Thanks a lot!

## 📊 Statistics

Statistics are updated at `2022-04-29T20:20:55+09:00`

### Code Lens

**NOTE:** It is the result of `tokei --hidden -- $(git ls-files)`.

```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 BASH                    4          131          105            9           17
 JSON                   11         1207         1207            0            0
 Lua                     6          221          201            6           14
 Makefile                1           96           83            0           13
 Markdown                2          165            0          114           51
 Python                  1           32           21            3            8
 Scheme                  5           91           82            1            8
 Shell                   6           97           78            9           10
 TOML                   11         2398         2112           28          258
 Vim script             25         1889         1695           62          132
 YAML                    4          446          348           52           46
 Zsh                     6          524          391           86           47
===============================================================================
 Total                  82         7297         6323          370          604
===============================================================================
```

### (Neo)vim Startup Time

**NOTE:** It is the result of
`hyperfine 'vim --not-a-term +quit' 'nvim --headless +quit'`.

```
Benchmark 1: vim --not-a-term +quit
  Time (mean ± σ):     365.9 ms ±   3.6 ms    [User: 267.3 ms, System: 91.4 ms]
  Range (min … max):   358.7 ms … 369.3 ms    10 runs

Benchmark 2: nvim --headless +quit
  Time (mean ± σ):     377.6 ms ±   3.0 ms    [User: 266.9 ms, System: 107.7 ms]
  Range (min … max):   373.7 ms … 381.7 ms    10 runs

Summary
  'vim --not-a-term +quit' ran
    1.03 ± 0.01 times faster than 'nvim --headless +quit'
```

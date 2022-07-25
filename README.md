# ![dotfiles](https://user-images.githubusercontent.com/81011153/180718947-cb2428f2-0f54-46a1-93c6-d54ad206c6a8.jpeg)

> ⚙ My configuration files and personal preferences

---

Table of Contents

<!--ts-->
* [dotfiles](#dotfiles)
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
      * [(neo)vim Startup Time](#neovim-startup-time)
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

- curl
- git
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

Statistics are updated at [`16c4ddb`](https://github.com/4513ECHO/dotfiles/commit/16c4ddb5eaf4dbe966b97cc4059c929f48dd2f9f).

### Code Lengths

It uses [tokei](https://github.com/XAMPPRocky/tokei) to measure.

<!--tokei-start-->
```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 BASH                   18          280          188           43           49
 JSON                   12         1283         1283            0            0
 Lua                    10          556          258          248           50
 Makefile                1           98           86            0           12
 Python                  1           32           21            3            8
 Scheme                  6          106           84           11           11
 Shell                   8          120           97           13           10
 Plain Text              1           35            0           24           11
 TOML                   11         2471         2166           35          270
 TypeScript              5          227          200            5           22
 Vim script             28         1955         1771           66          118
 YAML                    5          642          558           38           46
 Zsh                     6          519          389           85           45
-------------------------------------------------------------------------------
 Markdown                2          185            0          127           58
 |- YAML                 1            7            7            0            0
 (Total)                            192            7          127           58
===============================================================================
 Total                 114         8509         7101          698          710
===============================================================================
```
<!--tokei-end-->

### (neo)vim Startup Time

It uses [hyperfine](https://github.com/sharkdp/hyperfine) to benchmark.

<!--hyperfine-start-->
```
Benchmark 1: vim --not-a-term +quit
  Time (mean ± σ):     384.2 ms ±   7.6 ms    [User: 285.0 ms, System: 93.7 ms]
  Range (min … max):   373.1 ms … 400.3 ms    10 runs
 
Benchmark 2: nvim --headless +quit
  Time (mean ± σ):     467.9 ms ±   6.1 ms    [User: 344.3 ms, System: 120.0 ms]
  Range (min … max):   462.1 ms … 478.8 ms    10 runs
 
Summary
  'vim --not-a-term +quit' ran
    1.22 ± 0.03 times faster than 'nvim --headless +quit'
```
<!--hyperfine-end-->

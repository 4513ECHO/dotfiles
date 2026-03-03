# syntax=docker/dockerfile:1

# Build and install neovim HEAD
FROM ubuntu:25.04 AS nvim

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        gettext \
        git \
        ninja-build \
        rustup

# Rust 1.89 will produce mismatched_lifetime_syntaxes error
RUN rustup default 1.88

WORKDIR /opt/neovim
RUN git clone --filter=blob:none https://github.com/neovim/neovim .
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo \
         CMAKE_EXTRA_FLAGS='-DENABLE_WASMTIME=ON' \
         DEPS_CMAKE_FLAGS='-DUSE_BUNDLED_TS_PARSERS=OFF -DENABLE_WASMTIME=ON'
RUN make install

# Build and install vim HEAD
FROM ubuntu:25.04 AS vim

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y \
        build-essential \
        ca-certificates \
        gettext \
        git \
        libluajit-5.1-dev \
        libncurses-dev \
        luajit

WORKDIR /opt/vim
RUN git clone --filter=blob:none https://github.com/vim/vim .
RUN ./configure --enable-fail-if-missing \
                --enable-luainterp --with-luajit \
                --enable-autoservername \
                --enable-socketserver
RUN make -j$(nproc)
RUN make install

FROM ubuntu:25.04

ARG USERNAME=hibiki
ARG UID
ARG PASSWORD=hibiki

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg \
        less \
        luajit \
        sudo \
        unzip \
        zsh

COPY --from=nvim /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=nvim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=vim /usr/local/bin/vim /usr/local/bin/vim
COPY --from=vim /usr/local/share/vim /usr/local/share/vim

# Create user
RUN useradd -m -s /bin/zsh -u $UID -G sudo $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

ENV SHELL=/bin/zsh
# RUN curl -L https://4513echo.dev/dot | sh
COPY --chown=$USERNAME:$USERNAME . /home/$USERNAME/dotfiles
WORKDIR /home/$USERNAME/dotfiles
# Restore path hack for macOS
RUN git clean -fdX . && \
    git restore config/zsh && \
    make install
CMD ["/bin/zsh"]

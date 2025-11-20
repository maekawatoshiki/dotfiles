#!/bin/bash -eux

# dependencies
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    curl \
    git \
    gnupg2 \
    iputils-ping \
    jq \
    less \
    net-tools \
    openssh-client \
    tar \
    time \
    unzip \
    vim \
    xz-utils \
    zip \
    clang \
    gcc \
    llvm \
    lld \
    ccache \
    ninja-build \
    cmake \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    doxygen \
    zsh \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    git-lfs \
    htop \
    zlib1g-dev \
    openssh-server \
    rsync \
    libevent-dev \
    yacc \
    libncurses-dev \

# lld
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.lld" 30 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10
sudo update-alternatives --auto "ld"

# zsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"

cp ./zshrc ~/.zshrc
cp ./p10k.zsh ~/.p10k.zsh

mkdir -p ~/.ssh
cp ./ssh_config ~/.ssh/config

# git
ln -s "${PWD}/git/gitconfig" "${HOME}/.gitconfig"

# Build neovim

mkdir -p ~/work

(
  cd ~/work
  git clone https://github.com/neovim/neovim --depth 1 --recursive \
      && cd neovim \
      && CC=/usr/lib/ccache/clang CXX=/usr/lib/ccache/clang++ \
          make CMAKE_BUILD_TYPE=Release -j \
      && sudo make CMAKE_BUILD_TYPE=Release install -j
)

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.config/nvim/lua"
ln -s "${PWD}/vim/plugins.lua" "${HOME}/.config/nvim/lua/plugins.lua"
ln -s "${PWD}/vim/init.lua" "${HOME}/.config/nvim/init.lua"

# Install nodenv

if [ ! -d ~/.nodenv ]; then
  git clone https://github.com/nodenv/nodenv.git ~/.nodenv
  export PATH="${HOME}/.nodenv/bin:${PATH}"
  eval "$(nodenv init - zsh)"

  ## For some reason, we need this.
  git clone https://github.com/nodenv/node-build.git "$(nodenv root)/plugins/node-build"

  ## Install yarn
  git clone https://github.com/pine/nodenv-yarn-install.git "$(nodenv root)/plugins/nodenv-yarn-install"

  nodenv install 22.6.0
  nodenv global 22.6.0
fi

# Install pyenv

curl https://pyenv.run | bash

# Install goenv

if [ ! -d ~/.goenv ]; then
  git clone https://github.com/go-nv/goenv.git ~/.goenv
  export GOENV_ROOT="${HOME}/.goenv"
  export PATH="${GOENV_ROOT}/bin:${PATH}"
  eval "$(goenv init -)"

  goenv install 1.24.5
  goenv global 1.24.5
fi

# Install poetry

curl -sSL https://install.python-poetry.org | python3 -

# Install rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# tmux

(
  cd ~/work
  git clone https://github.com/tmux/tmux -b 3.4 --depth 1 \
      && cd tmux \
      && ./autogen.sh \
      && ./configure \
      && make -j \
      && sudo make install
)

git clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect ~/.tmux-resurrect
ln -s "${PWD}/tmux/tmux.conf" "${HOME}/.tmux.conf"

# Install tailscale

curl -fsSL https://tailscale.com/install.sh | sh

# Install bitwarden cli

yarn global add @bitwarden/cli@2024.6.0

# Install atuin

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Finish!

printf "\e[32mSetup complete!\e[m\n"

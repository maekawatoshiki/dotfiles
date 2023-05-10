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
    wget

# lld
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.lld" 30 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10
sudo update-alternatives --auto "ld"

# zsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp ./zshrc ~/.zshrc
cp ./p10k.zsh ~/.p10k.zsh

# Build neovim

mkdir -p ~/work

pushd ~/work
git clone https://github.com/neovim/neovim --depth 1 --recursive \
    && cd neovim \
    && CC=/usr/lib/ccache/clang CXX=/usr/lib/ccache/clang++ \
        make -j CMAKE_BUILD_TYPE=Release \
    && sudo make -j CMAKE_BUILD_TYPE=Release install
popd

mkdir /home/uint/.config
mkdir -p $HOME/.config/nvim/lua
ln -s $(pwd)/plugins.lua $HOME/.config/nvim/lua/plugins.lua
ln -s $(pwd)/init.vim $HOME/.config/nvim/init.vim

# Install nodenv

## https://github.com/nodenv/nodenv#basic-github-checkout
if [ ! -d ~/.nodenv ]; then
  git clone https://github.com/nodenv/nodenv.git ~/.nodenv
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init - zsh)"
fi

## For some reason, we need this.
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

## Install yarn
git clone https://github.com/pine/nodenv-yarn-install.git "$(nodenv root)/plugins/nodenv-yarn-install"

nodenv install 19.7.0
nodenv global 19.7.0

# Install rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

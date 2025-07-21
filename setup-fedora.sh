#!/bin/bash -eux

sudo dnf update -y
sudo dnf install -y \
    @development-tools \
    bash-completion \
    make \
    automake \
    gcc \
    g++ \
    kernel-devel \
    curl \
    git \
    gnupg2 \
    iputils \
    jq \
    less \
    net-tools \
    openssh-clients \
    tar \
    time \
    unzip \
    vim \
    xz \
    zip \
    clang \
    llvm \
    lld \
    ccache \
    ninja-build \
    cmake \
    gettext \
    libtool \
    autoconf \
    pkgconfig \
    doxygen \
    zsh \
    python3 \
    python3-pip \
    python3-virtualenv \
    wget \
    git-lfs \
    htop \
    zlib-devel \
    openssh-server \
    rsync \
    libevent-devel \
    bison \
    ncurses-devel \
    gettext-devel \
    neovim

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

# (
#   cd ~/work
#   git clone https://github.com/neovim/neovim --depth 1 --recursive \
#       && cd neovim \
#       && CC='clang' CXX='clang++' \
#           make -j CMAKE_BUILD_TYPE=Release \
#       && sudo make -j CMAKE_BUILD_TYPE=Release install
# )

# Install goenv

if [ ! -d ~/.goenv ]; then
  git clone https://github.com/go-nv/goenv.git ~/.goenv
  export GOENV_ROOT="${HOME}/.goenv"
  export PATH="${GOENV_ROOT}/bin:${PATH}"
  eval "$(goenv init -)"
  
  goenv install 1.24.5
  goenv global 1.24.5
fi

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.config/nvim/lua"
ln -s "${PWD}/vim/plugins.lua" "${HOME}/.config/nvim/lua/plugins.lua"
ln -s "${PWD}/vim/init.lua" "${HOME}/.config/nvim/init.lua"


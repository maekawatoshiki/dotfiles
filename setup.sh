#!/bin/bash
set -euxo pipefail

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
ZSH_CUSTOM="${HOME}/.oh-my-zsh-custom"

clone() {
    local repo_url=${1}
    local commit=${2}
    local target_dir=${3}
    git clone --filter=blob:none --no-checkout "${repo_url}" "${target_dir}"
    git -C "${target_dir}" fetch --depth=1 origin "${commit}"
    git -C "${target_dir}" checkout --detach "${commit}"
    test "$(git -C "${target_dir}" rev-parse HEAD)" = "${commit}"
}

mkdir -p "${ZSH_CUSTOM}/plugins" "${ZSH_CUSTOM}/themes"

clone https://github.com/ohmyzsh/ohmyzsh.git               "349b9e49ced7682e27927ffb34b6522f011f3e74" "${HOME}/.oh-my-zsh" # 2026-04-20
clone https://github.com/zsh-users/zsh-autosuggestions.git "85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5" "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" # 2025-06-24
clone https://github.com/romkatv/powerlevel10k.git         "604f19a9eaa18e76db2e60b8d446d5f879065f90" "${ZSH_CUSTOM}/themes/powerlevel10k" # 2026-03-14

cp ./zshrc ~/.zshrc
cp ./p10k.zsh ~/.p10k.zsh

mkdir -p ~/.ssh
ln -s "${PWD}/ssh/config" "${HOME}/.ssh/config"

# git
ln -s "${PWD}/git/gitconfig" "${HOME}/.gitconfig"

# Build neovim

mkdir -p ~/work

(
    cd ~/work
    # 2026-05-03
    clone https://github.com/neovim/neovim.git "7ed5609439ba83d75e972beb859245d998df09ea" ./neovim \
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
    clone https://github.com/nodenv/nodenv.git "a33f4a8f90be4dbbabf5a2b1fe0fa35676bb95b1" "${HOME}/.nodenv" # 2026-04-13
    export PATH="${HOME}/.nodenv/bin:${PATH}"
    eval "$(nodenv init - zsh)"

    ## For some reason, we need this.
    clone https://github.com/nodenv/node-build.git "d41e0a7c38abd870471a6a0bf91670349da69f78" "$(nodenv root)/plugins/node-build" # 2026-05-01

    ## Install yarn
    clone https://github.com/pine/nodenv-yarn-install.git "18abc07414a6e1ce5a5c7aff343785041966c1b9" "$(nodenv root)/plugins/nodenv-yarn-install" # 2019-03-30

    nodenv install 24.9.0
    nodenv global 24.9.0
fi

# Install pyenv

curl https://pyenv.run | bash

# Install poetry

curl -sSL https://install.python-poetry.org | python3 -

# Install rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# tmux

(
    cd ~/work
    # 2024-02-13, tag 3.4
    clone https://github.com/tmux/tmux.git "9ae69c3795ab5ef6b4d760f6398cd9281151f632" ./tmux \
        && cd tmux \
        && ./autogen.sh \
        && ./configure \
        && make -j \
        && sudo make install
)

clone https://github.com/tmux-plugins/tmux-resurrect.git "cff343cf9e81983d3da0c8562b01616f12e8d548" "${HOME}/.tmux-resurrect" # 2023-03-06
ln -s "${PWD}/tmux/tmux.conf" "${HOME}/.tmux.conf"

# Install tailscale

answer="n"
if [ -t 0 ]; then
    printf "Do you want to install Tailscale? (y/N): "
    read -r answer || answer="n"
fi

if [[ "$answer" =~ ^[Yy]$ ]]; then
    curl -fsSL https://tailscale.com/install.sh | sh
else
    echo "Skipping Tailscale installation."
fi

# Install bitwarden cli

if [ "${SETUP_BITWARDEN:-0}" = "1" ]; then
    yarn global add @bitwarden/cli@2024.6.0
fi

# Install atuin

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive

# Finish!

printf "\e[32mSetup complete!\e[m\n"

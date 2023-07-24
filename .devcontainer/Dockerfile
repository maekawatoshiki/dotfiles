FROM ubuntu:22.04

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates tzdata sudo \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo 'Asia/Tokyo' >/etc/timezone

RUN set -x \
    && echo "uint ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/ALL \
    && groupadd \
        --gid 5000 \
        uint \
    && useradd \
        --uid 5000 \
        --gid 5000 \
        --home-dir /home/uint \
        --create-home \
        --shell /bin/bash \
        uint \
    && chown uint -R /home/uint

USER uint

RUN set -x \
    && sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
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
    && sudo apt-get clean \
    && sudo rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN mkdir /home/uint/work

WORKDIR /home/uint/work

# RUN sudo chown uint -R /home/uint/

# Setup lld

RUN set -x \
    && sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
        lld \
    && sudo apt-get clean \
    && sudo rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.lld" 30 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20 \
    && sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10
RUN sudo update-alternatives --auto "ld"

# Install poetry

RUN curl -sSL https://install.python-poetry.org | python3 -

# Install Rust

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Setup node
RUN curl -L git.io/nodebrew | perl - setup
RUN export PATH=$HOME/.nodebrew/current/bin:$PATH \
    && nodebrew install v16.15.0 \
    && nodebrew use v16.15.0 \
    && npm install -g yarn

# Build neovim

# RUN git clone https://github.com/neovim/neovim --depth 1 --recursive \
#     && cd neovim \
#     && CC=/usr/lib/ccache/clang CXX=/usr/lib/ccache/clang++ \
#         make -j CMAKE_BUILD_TYPE=RelWithDebInfo \
#     && sudo make install
# COPY init.vim /home/uint/work/dotfiles/init.vim
# COPY plugins.lua /home/uint/work/dotfiles/plugins.lua
# COPY setup-nvim.sh /home/uint/work/dotfiles/setup-nvim.sh
# RUN mkdir /home/uint/.config
# RUN sudo chown uint -R /home/uint/.config
# RUN mkdir -p $HOME/.config/nvim/lua
# RUN ln -s $HOME/work/dotfiles/plugins.lua $HOME/.config/nvim/lua/plugins.lua
# RUN ln -s $HOME/work/dotfiles/init.vim $HOME/.config/nvim/init.vim

# Setup zsh

RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY zshrc ~/.zshrc
COPY p10k.zsh ~/.p10k.zsh

CMD ["/bin/zsh"]

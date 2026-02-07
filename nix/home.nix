{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "24.05";

  home.username = "uint";
  home.homeDirectory = "/Users/uint";

  home.packages = with pkgs; [
    # version control
    git
    git-lfs

    # network
    curl
    wget

    # editor
    neovim
    nixd
    helix

    # term
    tmux
    zsh

    # cli utils
    atuin
    btop
    coreutils
    ffmpeg
    findutils
    fzf
    htop
    imagemagick
    jq
    lsd
    pv
    slackdump
    tree
    watch
    lolcat
    xan
    hadolint
    mdcat
    scdoc
    cscope

    # build toolchain
    boost.dev
    ccache
    clangWrapper
    clang
    clang-tools
    cmake
    lld
    llvmPackages_21.openmp
    ninja
    pkg-config
    shellcheck

    # languages
    go
    nodenv
    pyenv

    # virtualization
    qemu

    # build deps
    bzip2
    gnutls
    libffi
    libiconv
    mimalloc
    openssl
    protobuf
    readline
    sqlite
    tcl
    tk
    xz
    xz.dev
    zlib
    zlib.dev
  ];

  programs.home-manager.enable = true;
}

{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "24.05";

  home.username = "uint";
  home.homeDirectory = "/Users/uint";

  home.packages = with pkgs; [
    git
    git-lfs
    curl
    wget
    neovim
    clang
    clang-tools
    lld
    ccache
    cmake
    ninja
    pkg-config
    boost.dev
    qemu
    go
    nodenv
    pyenv
    zsh
    tmux
    fzf
    btop
    htop
    shellcheck
    coreutils
    findutils
    tree
    jq
    watch
    pv
    ffmpeg
    imagemagick
    xz
    xz.dev
    zlib
    zlib.dev
    libiconv
    gnutls
    llvmPackages_21.openmp
    mimalloc
    protobuf
    readline
    libffi
    openssl
    sqlite
    bzip2
    tk
    tcl
    openssl
    slackdump
  ];

  programs.home-manager.enable = true;
}

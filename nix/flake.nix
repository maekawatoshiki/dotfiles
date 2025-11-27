{
  description = "uint package definition for aarch64-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system}.uint-packages = pkgs.buildEnv {
      name = "uint-packages";
      paths = [
        pkgs.git
        pkgs.git-lfs

        pkgs.curl
        pkgs.wget

        pkgs.neovim

        pkgs.clang
        pkgs.clang-tools
        pkgs.lld
        pkgs.ccache
        pkgs.cmake
        pkgs.ninja
        pkgs.pkg-config
        pkgs.boost.dev

        pkgs.qemu

        pkgs.go
        pkgs.nodenv
        pkgs.pyenv

        pkgs.zsh
        pkgs.tmux
        pkgs.fzf
        pkgs.btop
        pkgs.htop
        pkgs.shellcheck

        pkgs.coreutils
        pkgs.findutils
        pkgs.tree
        pkgs.jq
        pkgs.watch
        pkgs.pv

        pkgs.ffmpeg
        pkgs.imagemagick
        pkgs.xz
        pkgs.xz.dev
        pkgs.zlib
        pkgs.zlib.dev
        pkgs.libiconv
        pkgs.gnutls
        pkgs.llvmPackages_21.openmp
        pkgs.mimalloc
        pkgs.protobuf
        pkgs.readline
        pkgs.libffi
        pkgs.libuuid
        pkgs.openssl
        pkgs.sqlite
        pkgs.bzip2
        pkgs.tk
        pkgs.tcl
        pkgs.openssl

        pkgs.slackdump
      ];
    };

    apps.${system}.update = {
      type = "app";
      program = toString (pkgs.writeShellScript "update-script" ''
        set -eux
        nix flake update
        nix profile upgrade --all
      '');
    };
  };
}

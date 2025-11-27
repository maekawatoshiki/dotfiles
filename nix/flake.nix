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
        pkgs.curl
        pkgs.neovim
        pkgs.clang
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

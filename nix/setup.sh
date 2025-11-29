#!/bin/bash
set -euxo pipefail

mkdir -p ~/.config/home-manager
ln -s "${PWD}/home.nix" ~/.config/home-manager/home.nix
ln -s "${PWD}/flake.nix" ~/.config/home-manager/flake.nix
ln -s "${PWD}/flake.lock" ~/.config/home-manager/flake.lock

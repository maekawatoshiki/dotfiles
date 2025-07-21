#!/bin/bash

mkdir -p "${HOME}"/.config/nvim/lua
ln -s "${PWD}/vim/plugins.lua" "${HOME}/.config/nvim/lua/plugins.lua"
ln -s "${PWD}/vim/init.vim" "${HOME}/.config/nvim/init.vim"

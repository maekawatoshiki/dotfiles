#!/bin/bash
# https://github.com/nodenv/nodenv#basic-github-checkout

git clone https://github.com/nodenv/nodenv.git ~/.nodenv

# For some reason, we need this.
git clone https://github.com/nodenv/node-build.git "$(nodenv root)/plugins/node-build"

# Install yarn.
git clone https://github.com/pine/nodenv-yarn-install.git "$(nodenv root)/plugins/nodenv-yarn-install"


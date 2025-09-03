#!/bin/zsh

source ../zsh/lib/prun.zsh

prun curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

prun ln -sf `pwd`/nvm.zsh ../zsh/lib/nvm.zsh

# Install Node.js 20
prun source nvm.zsh
prun nvm install 20
prun nvm use 20
prun nvm alias default 20

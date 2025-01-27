#!/bin/bash

source ../zsh/scripts/utils.zsh

for f in `pwd`/*.ttf; do
  prun mkdir -p ~/.fonts
  prun ln -sf $f ~/.fonts
done

#!/bin/bash

source ../zsh/script/utils.zsh

for f in `pwd`/*.ttf; do
  prun mkdir -p ~/.fonts
  prun ln -sf $f ~/.fonts
done

#!/bin/bash

source ../tools/utils.zsh

for f in `pwd`/*.ttf; do
  mkdir -p ~/.fonts
  ln -sf $f ~/.fonts
done

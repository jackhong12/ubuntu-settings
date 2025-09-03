#!/bin/bash

source ../zsh/lib/prun.zsh

for f in `pwd`/*.ttf; do
  prun mkdir -p ~/.fonts
  prun ln -sf $f ~/.fonts
done

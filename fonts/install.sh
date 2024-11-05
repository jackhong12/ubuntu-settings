#!/bin/bash

source ../tools/utils.zsh

for f in `pwd`/*.ttf; do
  _show_and_run mkdir -p ~/.fonts
  _show_and_run ln -sf $f ~/.fonts
done

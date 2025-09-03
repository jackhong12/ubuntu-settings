#!/bin/bash

source ../zsh/lib/check_install.zsh
source ../zsh/lib/prun.zsh

check_install tmux

prun ln -sf `pwd`/.tmux.conf ~/
prun ln -sf `pwd`/.tmux.conf.local ~/

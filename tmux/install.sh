#!/bin/bash

source ../zsh/scripts/utils.zsh

check_install tmux

prun ln -sf `pwd`/.tmux.conf ~/
prun ln -sf `pwd`/.tmux.conf.local ~/

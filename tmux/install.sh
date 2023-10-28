#!/bin/bash

source ../tools/utils.zsh

check-install tmux

ln -sf `pwd`/.tmux.conf ~/
ln -sf `pwd`/.tmux.conf.local ~/

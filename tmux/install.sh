#!/bin/bash

source ../tools/utils.zsh

check-install tmux

_show_and_run ln -sf `pwd`/.tmux.conf ~/
_show_and_run ln -sf `pwd`/.tmux.conf.local ~/

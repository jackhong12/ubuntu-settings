#!/bin/zsh

source ../zsh/scripts/utils.zsh

prun check_install gdb
prun ln -sf `pwd`/.gdbinit ~/.gdbinit

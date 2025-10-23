#!/bin/zsh

source ../zsh/lib/prun.zsh
source ../zsh/lib/check_install.zsh

prun check_install gdb
prun ln -sf `pwd`/.gdbinit ~/.gdbinit

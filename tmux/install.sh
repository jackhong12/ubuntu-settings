#!/bin/bash

check_install () {
    for exe in "$@"; do
        if ! command -v $exe &> /dev/null; then
            sudo apt-get install -y $exe
        fi
    done
}

check_install tmux

ln -sf `pwd`/.tmux.conf ~/
ln -sf `pwd`/.tmux.conf.local ~/

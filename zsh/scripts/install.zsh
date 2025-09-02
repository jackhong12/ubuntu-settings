#!/bin/zsh

# This file contains functions to help install packages and set up the
# environment. It should be self-contained and not depend on other files.
#
# - prun: Print and run a command, showing the command before executing it.
# - check_install: Check if a package is installed, and install it if not.

# Only include this file once {{{
if [[ -v __INCLUDE_INSTALL_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_INSTALL_ZSH__=1
fi
# }}}

# prun: Print and run {{{

prun () {
  cmd="$@"
  printf "\033[0;32m"
  printf "$ $cmd\n"
  printf "\033[0m"
  eval "$cmd"
}

# }}} prun

# check_install: Check whether the binary exists. If not, install it by apt-get {{{
check_install () {
  for exe in "$@"; do
    if ! command -v $exe &> /dev/null; then
      prun sudo apt-get install -y $exe
    fi
  done
}

#}}} check_install

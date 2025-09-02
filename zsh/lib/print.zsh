#!/bin/zsh

# This file contains functions for printing colored text to the terminal. This
# should be a dependency-free file.

# Only include this file once. {{{
if [[ -v __INCLUDE_PRINT_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_PRINT_ZSH__=1
fi
# }}}

# perror: Print error {{{
perror () {
  _red $1
}
#}}} perror

# pinfo: Print information {{{
pinfo () {
  _green $1
}
#}}} pinfo

# _red {{{

_red () {
  printf "\033[0;31m$@\033[0m"
}

#}}} _red

# _green {{{

_green () {
  printf "\033[0;32m$@\033[0m"
}

#}}} _green

# _color_remove {{{

_color_remove () {
  sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g"
}

#}}} _color_remove

#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_PRUN_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_PRUN_ZSH__=1
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

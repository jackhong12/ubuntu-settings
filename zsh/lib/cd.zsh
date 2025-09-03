#!/bin/zsh

# This file contains the functions to change directory in the terminal.

# Only include this file once. {{{
if [[ -v __INCLUDE_CD_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_UTILS_CD__=1
fi
# }}}

# _pushd {{{

_pushd () {
  pushd $1 2>&1 > /dev/null
}
#}}} _pushd

# _popd {{{

_popd () {
  popd 2>&1 > /dev/null
}
#}}} _popd


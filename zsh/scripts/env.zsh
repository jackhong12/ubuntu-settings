#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_ENV_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ENV_ZSH__=1
fi
# }}}


__UBUNTU_SETTINGS_GIT_ROOT__="__SED_UBUNTU_SETTINGS_GIT_ROOT__"
__USETTING_ZSH_LIB_PATH__="__SED_USETTING_ZSH_LIB_PATH__"


# zlib-include: Function to source zlib if available {{{
# Usage:
#   zlib-include <file>

zlib-include () {
  # Only one argument is allowed
  if [[ $# -ne 1 ]]; then
    echo "zlib-include: Only one argument is allowed" >&2
    return 1
  fi

  zlib_path=$__USETTING_ZSH_LIB_PATH__/$1

  # Check if the file exists
  if [[ -f $zlib_path ]]; then
    source $zlib_path
  else
    echo "zlib-include: File '$zlib_path' not found" >&2
    return 1
  fi
}

# }}} zlib-include

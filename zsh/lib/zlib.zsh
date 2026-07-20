#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_ZLIB_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ZLIB_ZSH__=1
fi
# }}}


if [[ ! -v ZSH_LIB_PATH ]]; then
  echo "zlib.zsh: ZSH_LIB_PATH is not set. Re-run zsh/install.sh." >&2
  return 1
fi


# __zlib_flag_name: Map a file to its include-guard variable name {{{
# e.g. arguments.zsh -> __INCLUDE_ARGUMENTS_ZSH__, gcc-dev.zsh -> __INCLUDE_GCC_DEV_ZSH__
__zlib_flag_name () {
  local base=${1:t}     # basename
  base=${base%.zsh}     # strip .zsh extension
  base=${base//-/_}     # hyphens are not valid in variable names
  echo "__INCLUDE_${(U)base}_ZSH__"
}
# }}} __zlib_flag_name

# __zlib_source_once: Source a file at most once, guarded by its flag {{{
# The guard is derived from the file name here, so individual library files
# no longer need their own "only include once" block.
__zlib_source_once () {
  local file=$1
  local flag=$(__zlib_flag_name $file)

  # Already sourced?
  if [[ -v $flag ]]; then
    return 0
  fi

  typeset -g $flag=1
  source $file
}
# }}} __zlib_source_once

# zlib-include: Function to source zlib if available {{{
# Usage:
#   zlib-include <file>

zlib-include () {
  # Only one argument is allowed
  if [[ $# -ne 1 ]]; then
    echo "zlib-include: Only one argument is allowed" >&2
    return 1
  fi

  zlib_path=$ZSH_LIB_PATH/$1

  # Check if the file exists
  if [[ -f $zlib_path ]]; then
    __zlib_source_once $zlib_path
  else
    echo "zlib-include: File '$zlib_path' not found" >&2
    return 1
  fi
}

# }}} zlib-include

# zinclude: Function to source zlib if available {{{

zinclude () {
  zlib-include $@
}

# }}} zlib_include

# zinclude_all: Function to source all zlib files in a directory {{{

zinclude_all () {
  zlib_dir_path=$ZSH_LIB_PATH

  for file in $zlib_dir_path/*.zsh; do
    if [[ -f $file ]]; then
      __zlib_source_once $file
    fi
  done
}

# }}} zinclude_all

# zlib_path: Function to get the path of a zlib file {{{

zlib_path () {
  echo "$ZSH_LIB_PATH"
}
# }}} zlib_path

# zlib_repo_path: Function to get the path of a zlib file in the repo {{{

zlib_repo_path () {
  echo "${ZSH_LIB_PATH:P:h:h}"
}
# }}} zlib_repo_path

#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_ZLIB_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ZLIB_ZSH__=${0:A}
fi
# }}}

# Always include the directory containing this file so zlib.zsh is
# self-bootstrapping even when ZSH_LIB_PATH is not pre-set by ~/.zshrc.
typeset -g _zlib_dir=${0:A:h}
if [[ ! -v ZSH_LIB_PATH ]]; then
  ZSH_LIB_PATH=$_zlib_dir
elif [[ ";${ZSH_LIB_PATH};" != *";${_zlib_dir};"* ]]; then
  ZSH_LIB_PATH="${_zlib_dir};${ZSH_LIB_PATH}"
fi
export ZSH_LIB_PATH


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

  typeset -g $flag=$file
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

  local -a dirs=("${(s:;:)ZSH_LIB_PATH}")
  for dir in $dirs; do
    local candidate=$dir/$1
    if [[ -f $candidate ]]; then
      __zlib_source_once $candidate
      return 0
    fi
  done

  echo "zlib-include: '$1' not found in ZSH_LIB_PATH" >&2
  return 1
}

# }}} zlib-include

# zinclude: Function to source zlib if available {{{

zinclude () {
  zlib-include $@
}

# }}} zlib_include

# zinclude_all: Function to source all zlib files in a directory {{{

zinclude_all () {
  local -a dirs=("${(s:;:)ZSH_LIB_PATH}")
  for dir in $dirs; do
    for file in $dir/*.zsh; do
      if [[ -f $file ]]; then
        __zlib_source_once $file
      fi
    done
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
  echo "${_zlib_dir:h:h}"
}
# }}} zlib_repo_path

# zlib_list: Print all sourced zlib files {{{

zlib_list () {
  local var
  for var in ${(k)parameters[(I)__INCLUDE_*_ZSH__]}; do
    echo "${(P)var}"
  done
}

# }}} zlib_list

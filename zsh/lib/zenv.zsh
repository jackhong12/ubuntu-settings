#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_ZENV_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ZENV_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh
zinclude "prun.zsh"
zinclude "print.zsh"

_zenv_path="$HOME/build"
_zenv_info="version.txt"

# zenv: Add the path to $PATH {{{

zenv () {
  build_path=$_zenv_path/$1

  if [[ ! -d $build_path ]]; then
    perror "No such build folder: $build_path\n"
    return 1
  fi

  bin_path=$build_path/bin
  if [[ ! -d $bin_path ]]; then
    perror "No bin folder in build folder: $bin_path\n"
    return 1
  fi

  export PATH=$bin_path:$PATH
  printf "Add Path: "
  pinfo "$bin_path\n"

  if [[ -f $build_path/$_zenv_info ]]; then
    pinfo "Version:\n"
    cat $build_path/$_zenv_info
  fi
}

_zenv () {
  if [[ ! -d $_zenv_path ]]; then
    return 0
  fi

  local dirs
  dirs=(${(f)"$(find $_zenv_path -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"} )
  compadd -- $dirs
}

compdef _zenv zenv

# }}} zenv: Add the path to $PATH

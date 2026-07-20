#!/bin/zsh


# check_install: Check whether the binary exists. If not, install it by apt-get {{{

if [[ -v __INCLUDE_ZLIB_ZSH__ ]]; then
  zinclude "prun.zsh"

  check_install () {
    for exe in "$@"; do
      if ! command -v $exe &> /dev/null; then
        prun sudo apt-get install -y $exe
      fi
    done
  }

else
  __prun () {
    cmd="$@"
    printf "\033[0;32m"
    printf "$ $cmd\n"
    printf "\033[0m"
    eval "$cmd"
  }

  # Self-contaned version
  check_install () {
    for exe in "$@"; do
      if ! command -v $exe &> /dev/null; then
        __prun sudo apt-get install -y $exe
      fi
    done
  }
fi

#}}} check_install

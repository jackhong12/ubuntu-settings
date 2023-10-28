#!/bin/zsh

#> utils {{{
# zsh-remove-path
# - Remove variables __rp_*
#   $ zsh-remove-path [file]
#
# zsh-move-config
# - Move *.zsh to ~/.zsh
#   $ zsh-move-config
#
# git-root
# - Show git root directory
#   $ git-root
#
# Colors
# - _red
# - _green
#
# Change folders
# - _pushd
# - _popd
#
# check-install
#   Download uninstalled packages

# zsh-remove-path {{{
# zsh-remove-path
# zsh-remove-path [file]

zsh-remove-path () {
  if [ "$#" -ne 1 ]; then
    echo "zsh-remove-path [file]"
    return 1
  fi
  sed -i -r "s|^(__rp_)([0-9a-zA-Z_]+)=.*|\1\2=\2_needed_to_replaced|g" $1
}

#}}} zsh-remove-path

# zsh-move-config {{{

zsh-move-config () {
  set -x
  mkdir -p ~/.zsh
  for f in `pwd`/*.zsh; do
    # default change __rp_root to current git root directory
    sed -i -r "s|^__rp_root=.*|__rp_root=$(git-root)|g" $f
    ln -sf $f ~/.zsh
  done
}
#}}} zsh-move-config

# git-root {{{

git-root () {
  echo $(git rev-parse --show-toplevel)
}
#}}} git-root

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

# check-install {{{

check-install () {
  for exe in "$@"; do
    if ! command -v $exe &> /dev/null; then
      sudo apt-get install -y $exe
    fi
  done
}

#}}} check-install

#}}} utils

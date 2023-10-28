#!/bin/zsh

#> utils {{{
# zsh-remove-path
# - Remove variables __rp_*
#   $ zsh-remove-path [file]
#
# zsh-move-config
# - Move *.zsh to ~/.zsh
#   $ zsh-move-config

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
    ln -sf $f ~/.zsh
  done
}
#}}} zsh-move-config

#}}} utils

#!/bin/zsh

source ~/.zsh/zlib.zsh
zinclude "prun.zsh"

# ln_sf_check: Create a symbolic link if it doesn't exist. {{{
ln_sf_check () {
  # If the arguments are smaller than 2, return 1.
  if [ $# -lt 2 ]; then
    return 1
  fi

  # If the target file has already been linked, return 0.
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    return 0
  fi

  prun ln -sf "$1" "$2"
}
# }}} ln_sf_check

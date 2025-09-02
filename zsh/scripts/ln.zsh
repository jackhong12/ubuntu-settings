#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_LN_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_LN_ZSH__=1
fi
# }}}

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

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

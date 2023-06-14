#!/bin/bash
file=~/.zshrc

write () {
  echo "$@" >> $file
}

write """
# zsh-help {{{
alias zsh_help=`pwd`/zsh_help.py

h () {
  zsh_help ~/.zshrc $@
}
#}}}
"""


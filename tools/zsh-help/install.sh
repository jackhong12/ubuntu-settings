#!/bin/bash
file=~/.zshrc

write () {
  echo "$@" >> $file
}

write """
# zsh-help {{{
alias zsh_help=`pwd`/zsh_help.py

#> zh: Show help messages {{{
# USAGE
# $ zh [command]
zh () {
  zsh_help -d .zsh ~/.zshrc \$@
}
#}}}
#}}}
"""

mkdir -p ~/.zsh

#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# grepex: Exclude unimportant files {{{
grepex () {
  prun grep \
    --exclude=\*Parse.c \
    --exclude=tags \
    $@
}

# }}}

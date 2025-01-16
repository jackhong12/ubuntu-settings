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
  yacc_opt=""
  for f in $(find -name "*Parse.c"); do
    yacc_opt+=" --exclude=$f"
  done

  prun grep \
    --exclude=tags \
    $yacc_opt \
    $@
}

# }}} grepex

# grepr: Grep recursively and solve the links automatically {{{
grepr () {
  grep -R $@
}
# }}} grepr

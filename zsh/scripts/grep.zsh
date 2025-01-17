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
    yacc_opt+=" --exclude=$(basename -- $f)"
  done

  lex_opt=""
  for f in $(find -name "*Lex.c"); do
    lex_opt+=" --exclude=$(basename -- $f)"
  done

  swp_opt=""
  for f in $(find -name "*.swp"); do
    swp_opt+=" --exclude=$(basename -- $f)"
  done

  prun grep \
    --exclude=tags \
    $yacc_opt \
    $lex_opt \
    $swp_opt \
    --exclude=nettran.log \
    --exclude=temp_in \
    --exclude=errors \
    $@
}

# }}} grepex

# grepr: Grep recursively and solve the links automatically {{{
grepr () {
  grep -R $@
}
# }}} grepr

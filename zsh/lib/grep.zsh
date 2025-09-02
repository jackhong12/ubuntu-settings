#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_GREP_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_GREP_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh
zinclude "prun.zsh"

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

alias grepp="grep --exclude-dir={.git,.cache} --exclude=\"*.profile\" "

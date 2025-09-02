#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_CTAGS_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ENV_CTAGS__=1
fi
# }}}

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# ctags_gen_c: Generate tags for c code {{{

ctags_gen_c () {
  prun ctags -R -h ".h.hpp.p" --c++-kinds=+p --languages=C,C++ --langmap=C:.l.y.c $@
}

# }}} ctags_gen_c

# ctags_gen_zsh: Generate tags for zsh shell {{{
ctags_gen_zsh () {
  prun ctags -R --languages=Sh --langmap=Sh:.zsh --extras=+q -f ~/.zsh/tags ~/.zsh
}

# }}} ctags_gen_zsh

#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# ctags_gen_c: Generate tags for c code {{{

ctags_gen_c () {
  _show_and_run ctags -R -h ".h.hpp.p" --c++-kinds=+p --languages=C,C++ --langmap=C:.l.y.c $@
}

# }}} ctags_gen_c

# ctags_gen_zsh: Generate tags for zsh shell {{{
ctags_gen_zsh () {
  _show_and_run ctags -R --languages=Sh --langmap=Sh:.zsh --extras=+q -f ~/.zsh/tags ~/.zsh
}

# }}} ctags_gen_zsh

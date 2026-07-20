#!/bin/zsh

zinclude "prun.zsh"

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

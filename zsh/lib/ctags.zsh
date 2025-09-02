#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_CTAGS_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ENV_CTAGS__=1
fi
# }}}

source ~/.zsh/zlib.zsh
zlib_include "prun.zsh"

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

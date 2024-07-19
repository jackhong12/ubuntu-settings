#!/bin/zsh

#> ctags: Macros for ctags {{{
# ctags_gen_c: Generate tags for c code.

ctags_gen_c () {
  ctags -R -h ".h.hpp.p" --c++-kinds=+p $@
}

# }}} ctags

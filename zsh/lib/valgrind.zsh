#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_VALGRIND_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_VALGRIND_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh

valgrind_memory_check () {
  valgrind --tool=helgrind $@
}

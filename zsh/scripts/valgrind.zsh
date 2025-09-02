#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_VALGRIND_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ENV_VALGRIND__=1
fi
# }}}

valgrind_memory_check () {
  valgrind --tool=helgrind $@
}

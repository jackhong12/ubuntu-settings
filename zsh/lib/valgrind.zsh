#!/bin/zsh

source ~/.zsh/zlib.zsh

valgrind_memory_check () {
  valgrind --tool=helgrind $@
}

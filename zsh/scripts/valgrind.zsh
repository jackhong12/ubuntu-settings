#!/bin/zsh

valgrind_memory_check () {
  valgrind --tool=helgrind $@
}

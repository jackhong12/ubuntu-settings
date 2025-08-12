#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

__llvm_root_path="$HOME/open-source/llvm-project"
__llvm_build_path="$HOME/projects/llvm-project"
__llvm_folder_debug="debug"
__llvm_folder_release="release"
__llvm_linker="lld"

# __llvm_get_root_path {{{
__llvm_get_root_path() {
  echo "$__llvm_root_path"
}

# }}} __llvm_get_root_path

# __llvm_get_cmake_path {{{
__llvm_get_cmake_path () {
  echo "$__llvm_root_path/llvm"
}
# }}} __llvm_get_cmake_path

# __llvm_get_build_path {{{
__llvm_get_build_path () {
  echo "$__llvm_build_path"
}
# }}} __llvm_get_build_path

# __llvm_get_release_path {{{
__llvm_get_release_path () {
  local build_path="$(__llvm_get_build_path)/$__llvm_folder_release"
  mkdir -p "$build_path"
  echo "$build_path"
}
# }}} __llvm_get_release_path

# __llvm_get_debug_path {{{
__llvm_get_debug_path () {
  local build_path="$(__llvm_get_build_path)/$__llvm_folder_debug"
  mkdir -p $build_path
  echo $build_path
}
# }}} __llvm_get_debug_path

# jllvm-cmake-debug {{{

jllvm-cmake-debug() {
  local build_path="$(__llvm_get_debug_path)"
  _pushd $build_path
  prun cmake \
    -G Ninja \
    $(__llvm_get_cmake_path) \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DLLVM_USE_LINKER="$__llvm_linker" \
    $@

  prun ln -sf "$(pwd)/compile_commands.json" "$(__llvm_get_root_path)/compile_commands.json"

  pinfo "Build Path: "; printf "$build_path\n"

  _popd
}

# }}} jllvm-cmake-debug

# __llvm_ninja_completion {{{
__llvm_ninja_completion () {
  _arguments \
    '-j[Set the number of cores]:nproc:($(nproc))' \
    '*:target:( all opt check-all )'
}

# }}} __llvm_ninja_completion

# jllvm-ninja-debug {{{
jllvm-ninja-debug() {
  local build_path="$(__llvm_get_debug_path)"
  _pushd $build_path
  prun ninja $@
  pinfo "Build Path: "; printf "$build_path\n"
  _popd
}

compdef __llvm_ninja_completion jllvm-ninja-debug
# }}} jllvm-ninja-debug

# jllvm-setenv-debug {{{

jllvm-setenv-debug() {
  local build_path="$(__llvm_get_debug_path)"
  export PATH="$build_path/bin:$PATH"
  pinfo "Add PATH: $build_path/bin"
}

# }}} jllvm-setenv-debug



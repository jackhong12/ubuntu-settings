#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_LLVM_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_LLVM_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh
zinclude "arguments.zsh"
zinclude "print.zsh"
zinclude "yes.zsh"

_llvm_source_path="$HOME/llvm-project"
_llvm_build_path="$HOME/build"
_llvm_build_prefix="llvm"
_llvm_build_info="version.txt"


# --type=<Debug|Release>: Specify build type (default: Debug)
# --suffix=<string>     : Optional suffix for build directory
# --remake              : If specified, remove existing build directory before configuring
# --target=<string>     : Specify utility to build

# zllvm_get_build_path: Get LLVM build path {{{
zllvm_get_build_path () {

  local build_type=$(get_arguments "--type" "Debug" "$@")
  local build_path="$_llvm_build_path/$_llvm_build_prefix"

  if [[ $build_type == "Release" ]]; then
    build_path+="_opt"
  elif [[ $build_type == "Debug" ]]; then
    build_path+="_dbx"
  else
    perror "Invalid build type '$build_type'. Use 'Debug' or 'Release'.\n"
    return 1
  fi

  if suffix=$(get_arguments "--suffix" "" "$@"); then
    build_path+="_$suffix"
  fi

  echo $build_path
  return 0
}
# }}} zllvm_get_build_path

# zllvm_cmake: Configure LLVM build with CMake {{{

zllvm_cmake () {
  if [[ ! -d $_llvm_source_path ]]; then
    perror "LLVM source path '$_llvm_source_path' does not exist.\n"
    return 1
  fi

  if ! build_path=$(zllvm_get_build_path "$@"); then
    return 1
  fi

  local llvm_cmake_path=$_llvm_source_path"/llvm"
  local cmd="cmake -G Ninja $llvm_cmake_path -DLLVM_ENABLE_PROJECTS=\"clang;lld;compiler-rt\""
  local build_type=$(get_arguments "--type" "Debug" "$@")
  if [[ $build_type == "Release" ]]; then
    cmd+=" -DCMAKE_BUILD_TYPE=Release"
  elif [[ $build_type == "Debug" ]]; then
    cmd+=" -DCMAKE_BUILD_TYPE=Debug"
  else
    perror "Invalid build type '$build_type'. Use 'Debug' or 'Release'.\n"
    return 1
  fi

  if [[ -d $build_path ]]; then
    if check_arguments "--remake" "$@"; then
      printf "Removing existing build directory at '$build_path'.\n"
      if check_yes; then
        pinfo "Removing build directory...\n"
        rm -rf $build_path
      fi
    fi
  fi

  if [[ -d $build_path ]]; then
    pinfo "Cmake file already exists at '$build_path'. Skipping cmake configuration.\n"
    return 0
  else
    mkdir -p $build_path
  fi

  local current_path=$(pwd)
  cd $build_path
  prun "$cmd"

  cd $_llvm_source_path
  git_branch=$(git rev-parse --abbrev-ref HEAD)

  cd $build_path
  echo "LLVM Build Information" > $_llvm_build_info
  echo "- Build Type: $build_type" >> $_llvm_build_info
  echo "- Git Branch: $git_branch" >> $_llvm_build_info
  echo "- Build Time: $(date)" >> $_llvm_build_info
  echo "- Cmake: $cmd" >> $_llvm_build_info

  cd $current_path
}

# }}} zllvm_cmake


# zllvm_build: Build LLVM using Ninja {{{

zllvm_build () {
  if ! zllvm_cmake "$@"; then
    return 1
  fi

  if ! build_path=$(zllvm_get_build_path "$@"); then
    return 1
  fi

  local current_path=$(pwd)
  prun "cd $build_path"

  if target=$(get_arguments "--target" "" "$@"); then
    prun "ninja -j $(nproc) $target"
    return 0
  else
    prun "ninja -j $(nproc)"
  fi

  cd $current_path
}

# }}} zllvm_build

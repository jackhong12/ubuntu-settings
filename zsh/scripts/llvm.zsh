#!/bin/zsh

if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi

my_git_name=main
llvm_git_name=llvm_project_main
llvm_url="https://github.com/llvm/llvm-project.git"
__llvm_build_root_dir=build
__llvm_cc=clang
__llvm_cxx=clang++

# llvm_git_update: Sync with the officail branch {{{
llvm_git_update () {
  if _llvm_is_git_init; then
    # nothing
  else
    _llvm_git_init
  fi

  _show_and_run git fetch $llvm_git_name
  _show_and_run git checkout $my_git_name
  _show_and_run git merge $llvm_git_name/main
  _show_and_run git push
}
# }}} llvm_git_update

# llvm_format: Fomrat the code {{{
llvm_format () {
  _show_and_run git clang-format HEAD~1
  _show_and_run git commit --amend -a
}
# }}} llvm_format

# llvm_config: Configure llvm code {{{
_llvm_config_help="""
Configure llvm code.
  $ llvm_build <build type> <projects>

  - build type: <Release>
  - projects: <libc>

  - Example:
    - $ llvm_config: configure the current project
    - $ llvm_config build
    - $ llvm_config build Release libc
"""
llvm_config () {
  root_path=$(git-root)
  if [ $? -ne 0 ]; then
    _perr "Please run the command under the llvm project.\n"
    exit 1
  fi

  project_name=$(_llvm_project_name)
  build_path=$(_llvm_build_path)

  _pushd $root_path

  if [ $# -eq 0 ]; then
    build_type=Release
    build_projects=libc
  elif [ $# -eq 1 ]; then
    build_type=$1
    build_projects=libc
  elif [ $# -eq 2 ]; then
    build_type=$1
    build_projects=$2
  fi

  _show_and_run CC=$__llvm_cc CXX=$__llvm_cxx cmake -S llvm -B $build_path -G Ninja -DCMAKE_BUILD_TYPE=$build_type -DLLVM_ENABLE_PROJECTS="$build_projects"

  info="""
    Project Name   : $project_name
    Build Path     : $root_path/$build_path
    Build Type     : $build_type
    Enable Projects: $build_projects
    Compilers      : $__llvm_cc/$__llvm_cxx
  """
  _pinf "$info"

  _popd
}
# }}} llvm_build

# llvm_build_remove: Remove the build of the current project {{{

llvm_build_remove () {
  root_path=$(git-root)
  if [ $? -ne 0 ]; then
    _perr "Please run the command under the llvm project.\n"
    exit 1
  fi

  build_path=$(_llvm_build_path)
  _show_and_run rm -rf $root_path/$build_path
}

# }}} llvm_build_remove

# llvm_build: Build the code {{{
llvm_build () {
  root_path=$(git-root)
  if [ $? -ne 0 ]; then
    _perr "Please run the command under the llvm project.\n"
    return 1
  fi

  _pushd $root_path

  build_path=$(_llvm_build_path)
  _show_and_run ninja -C $build_path $@

  _popd
}
# }}} llvm_build

# Basic function
# _llvm_git_init {{{
_llvm_git_init () {
  _show_and_run git remote add $llvm_git_name $llvm_url
}
# }}} _llvm_git_init

# _llvm_git_remove {{{
_llvm_git_remove () {
  _show_and_run git remote remove $llvm_git_name
}
# }}} _llvm_git_remove

# _llvm_is_git_init {{{
_llvm_is_git_init () {
  git remote | grep $llvm_git_name > /dev/null
  return $?
}
# }}} _llvm_is_git_init

# _llvm_project_name {{{
_llvm_project_name () {
  branch=$(git-branch-name)
  if [ $? -eq 0 ]; then
    echo $branch
    return 0
  fi
  return -1
}

# }}} _llvm_project_name

# _llvm_build_path {{{
_llvm_build_path () {
  branch=$(_llvm_project_name)
  if [ $? -eq 0 ]; then
    mkdir -p $__llvm_build_root_dir
    echo $__llvm_build_root_dir/$branch
    return 0
  fi
  return -1
}

# }}} _llvm_build_path

# Note
#> libc {{{
# 1. Configuration
#   $ cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="libc"
# 2. Build
#   $ ninja -C build libc
# 3. Test
#   $ ninja -C build check-libc

#}}}

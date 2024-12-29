#!/bin/zsh

if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi

my_git_name=main
llvm_git_name=llvm_project_main
llvm_url="https://github.com/llvm/llvm-project.git"

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

# Basic function
# _llvm_git_init {{{
_llvm_git_init () {
  _show_and_run git remote add $llvm_git_name $llvm_url
}
# }}} _llvm_is_git_init

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

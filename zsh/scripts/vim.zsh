#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# vime: Auto-open changed files {{{
vime () {
  if git-is; then
    # git repo
  else
    # p4 repo
    dir=$(p4-root)
    _show_and_run _pushd $dir
    _show_and_run vim $(p4 opened | sed -E "s://pv/icv/([a-z0-9]+\.[_a-z0-9]+/rel|dev)/([^#]*).*:\2:g")
    _show_and_run _popd
  fi
}

# }}} vime

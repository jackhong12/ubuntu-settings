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
    prun _pushd $dir
    prun vim $(p4 opened | sed -E "s://pv/icv/([a-z0-9]+\.[_a-z0-9]+/rel|dev)/([^#]*).*:\2:g")
    prun _popd
  fi
}

# }}} vime

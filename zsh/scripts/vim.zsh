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
  if git_is; then
    # git repo
  else
    # p4 repo
    dir=$(p4_client_root)
    files=$(p4 opened | sed -E "s://pv/icv/([a-z0-9]+\.[_a-z0-9]+/rel|dev)/([^#]*).*:$dir/\2:g" | tr '\n' ' ')
    if [[ ${#files} -gt 0 ]]; then
      prun vim $files
    fi
  fi
}

# }}} vime

#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_VIM_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_VIM_ZSH__=1
fi
# }}}

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
    files=$(git status | grep modified | sed "s/\tmodified:   //g" | tr '\n' ' ')
    prun vim $files
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

# vimp: Open the files in the previous commit {{{

vimp () {
  if git_is; then
    # git repo
    files=$(git diff-tree --no-commit-id --name-only -r HEAD | tr '\n' '$' | sed 's:^:\$:g' | sed 's:\$: \\\n    :g')
    prun vim $files
  else
    # TODO: p4 repo
  fi
}

# }}} vimp

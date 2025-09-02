#!/bin/zsh

# Only include this file once. {{{
if [[ -v __INCLUDE_UTILS_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_UTILS_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh

# Fix no command complete. {{{
if [[ $SHELL == "/usr/bin/bash" ]]; then
  autoload -U +X bashcompinit && bashcompinit
  autoload -U +X compinit && compinit
elif [[ $SHELL == *zsh* ]]; then
  autoload -Uz compinit
  compinit
fi
# }}}

# Basic Commands:

# zsh-remove-path {{{
# @DOC
# ### zsh-remove-path
# For safety issue, remove all variables started with `__rp_`.
# - zsh-remove-path [file]
#

zsh-remove-path () {
  if [ "$#" -ne 1 ]; then
    echo "zsh-remove-path [file]"
    return 1
  fi
  sed -i -r "s|^(__rp_)([0-9a-zA-Z_]+)=.*|\1\2=\2_needed_to_replaced|g" $1
}

#}}} zsh-remove-path

# zsh-move-config {{{
# @DOC
# ### zsh-move-config
# Move all *.zsh under the current diretory to `~/.zsh` and resolve variable __rp_root.
# - zsh-move-config
#

zsh-move-config () {
  set -x
  mkdir -p ~/.zsh
  for f in `pwd`/*.zsh; do
    # default change __rp_root to current git root directory
    sed -i -r "s|^__rp_root=.*|__rp_root=$(git-root)|g" $f
    ln -sf $f ~/.zsh
  done
}
#}}} zsh-move-config

# git_is: Whether under a git repo {{{
git_is () {
  git status > /dev/null 2>&1
  return $?
}

# }}} git_is

# git-root {{{
git-root () {
  git_root=$(git rev-parse --show-toplevel 2> /dev/null )
  if [ $? -eq 0 ]; then
    echo $git_root
    return 0
  fi
  return -1
}

#}}} git-root

# git-branch-name: Get the current branch name {{{
git-branch-name () {
  git_root=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [ $? -eq 0 ]; then
    echo $git_root
    return 0
  fi
  return -1
}

# }}} git-branch-name

# p4-root: Get the root of a p4 repo {{{
p4-root () {
  root_path=$(p4 info | grep "Client root:" | sed -E "s|Client root: ||g")
  echo $root_path
  return $?
}

# }}} p4-root

# p4_is: Whether under a p4 repo {{{
p4_is () {
  p4 status > /dev/null 2>&1
  return $?
}

# }}} p4_is

# p4_client_root: Get the client root of p4 repo {{{
p4_client_root () {
  root_path=$(p4 info | grep "Client root:" | sed -E "s|Client root: ||g")
  echo $root_path
  return $?
}

# }}} p4_client_root

# _pushd {{{

_pushd () {
  pushd $1 2>&1 > /dev/null
}
#}}} _pushd

# _popd {{{

_popd () {
  popd 2>&1 > /dev/null
}
#}}} _popd

# _test_and_set: If the variable is not defined, define it {{{
_test_and_set () {
  if [[ -z "${(P)1}" ]]; then
    if [ "$#" -eq 1 ]; then
      export $1=1
    else
      export $1=$2
    fi
  fi
}
# }}} _test_and_set

# tmuxsn: Get current tmux session name {{{
tmuxsn () {
  session=$(tmux display-message -p '#S')
  echo "$session"
}
# }}} tmuxsn


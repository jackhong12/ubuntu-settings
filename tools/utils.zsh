#!/bin/zsh


#> utils: Utilities for zsh {{{
# zsh-remove-path
# - Remove variables __rp_*
#   $ zsh-remove-path [file]
#
# zsh-move-config
# - Move *.zsh to ~/.zsh
#   $ zsh-move-config
#
# git-root
# - Show git root directory
#   $ git-root
#
# Colors
# - _red
# - _green
# - _color_remove
#
# Change folders
# - _pushd
# - _popd
#
# check-install
#   Download uninstalled packages
#
# _info_command

# zsh-remove-path {{{
# zsh-remove-path
# zsh-remove-path [file]

zsh-remove-path () {
  if [ "$#" -ne 1 ]; then
    echo "zsh-remove-path [file]"
    return 1
  fi
  sed -i -r "s|^(__rp_)([0-9a-zA-Z_]+)=.*|\1\2=\2_needed_to_replaced|g" $1
}

#}}} zsh-remove-path

# zsh-move-config {{{

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

# git-root {{{

git-root () {
  echo $(git rev-parse --show-toplevel)
}
#}}} git-root

# _red {{{

_red () {
  printf "\033[0;31m$@\033[0m"
}

#}}} _red

# _green {{{

_green () {
  printf "\033[0;32m$@\033[0m"
}

#}}} _green

# _color_remove {{{

_color_remove () {
  sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g"
}

#}}} _color_remove

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

# check-install {{{

check-install () {
  for exe in "$@"; do
    if ! command -v $exe &> /dev/null; then
      sudo apt-get install -y $exe
    fi
  done
}

#}}} check-install

# _info_command {{{

alias _info_command="set -x"
#}}} _info_command

#}}} utils

#> tmux: tmux utilities {{{
# tmuxsn: Show current tmux session name
#
# tentry: Attach to session entry
#
# texist: Tmux checking
#   - Check whether using tmux
#     $ texist
#   - Check whether tmux session exists
#     $ texist [session name]

# varialbes for tmux
_tmux_entry_session_name=entry

# tmuxsn {{{

tmuxsn () {
  session=$(tmux display-message -p '#S')
  echo "$session"
}
#}}} tmuxsn

# tmuxsns {{{
tmuxsns () {
  echo $(tmux ls | sed -r "s|([^ ]*):.*|\1|")
}
#}}} tmuxsns

# tentry {{{

tentry () {
  if ! texist $_tmux_entry_session_name; then
    tmux new -d -s $_tmux_entry_session_name
  fi

  if texist; then
    tmux switch -t $_tmux_entry_session_name
  else
    tmux attach -t $_tmux_entry_session_name
  fi
}
#}}} tentry

# texist {{{

texist () {
  if [ "$#" -eq 1 ]; then
    for sn in `tmuxsns`; do
      if [[ "$sn" == "$1" ]]; then
        return 0;
      fi
    done
    return 1;
  fi

  if [[ -v TMUX ]]; then
    return 0;
  else
    return 1;
  fi
}
#}}} texist

#}}} tmux

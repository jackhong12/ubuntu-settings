#!/bin/zsh

#> uutils: Utilities for zsh {{{
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
# Print messages
# - _pmsg (white)
# - _pinf (green)
# - _perr (red)
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
# info_command
# - Start showing information
#   $ _info
# - End showing information
#   $ _info_end
# - info_command_turn_on
#   Turn on info command
# - info_command_turn_off
#   Turn off info command
#
# _test_and_set: If the variable is not defined, define it.
# - export var1=var2
#   $ _test_and_set var1=var2
# - export var1=1
#   $ _test_and_set var1=1

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

# _pmsg {{{
_pmsg () {
  printf "$@"
}
#}}} _pmsg

# _perr {{{
_perr () {
  _red $1
}
#}}} _perr

# _pinf {{{
_pinf () {
  _green $1
}
#}}} _pinf

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

# LEVEL:
#   1: INFO
#   2: WARNING
#   3: ERROR
export _DEBUG_pmsg_LEVEL=1
alias _info_command="set -x"

_info () {
  if [[ -v _DEBUG_pmsg_LEVEL ]] && [ "$_DEBUG_pmsg_LEVEL" -ge 1 ]; then
    set -x
  fi
}

_info_end () {
  if [[ -v _DEBUG_pmsg_LEVEL ]] && [ "$_DEBUG_pmsg_LEVEL" -ge 1 ]; then
    set +x
  fi
}

info_command_turn_on () {
  export _DEBUG_pmsg_LEVEL=1
}

info_command_turn_off () {
  export _DEBUG_pmsg_LEVEL=0
}

#}}} _info_command

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

#}}} uutils

#> utmux: Utilities for tmux {{{
# tmuxsn: Show current tmux session name
#
# tmuxsns: Show all tmux session names
#
# tprojectns: Show all names of tmux projects
#
# tentry: Attach to session entry
#
# texist: Tmux checking
#   - Check whether using tmux
#     $ texist
#   - Check whether tmux session exists
#     $ texist [session name]
#
# tproject
#   - tinit [project]: initialize a new project
#
# tj: Quick jump
#
# tissuep: The path of issue folder
#
# tsrcp: The path of source folder

if [[ -v TPROJECT_ENABLE ]]; then

# varialbes for tmux
_tmux_entry_session_name=entry
export _tproject_src_root=~/project
export _tproject_issue_root=~/project

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

# tprojectns: show all tmux projects {{{
tprojectns () {
  ls $_tproject_src_root
}

# }}} tprojectns

# tattach {{{

tattach () {
  if ! texist $1; then
    tmux new -d -s $1
  fi

  if texist; then
    tmux switch -t $1
  else
    tmux attach -t $1
  fi
}
#}}}

# tentry {{{

tentry () {
  tattach $_tmux_entry_session_name
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

# tinit {{{

# hook function
tinit_src_dir () {
}

# hook function
tinit_issue_dir () {
}

tinit () {
  if [ "$#" -ne 1 ]; then
    return 1;
  fi

  # initialize resources
  srcp=$_tproject_src_root/$1
  issuep=$_tproject_issue_root/$1
  mkdir -p $srcp
  mkdir -p $issuep
  touch $issuep/note.md

  # prepare tmux
  tattach $1
}
#}}} tinit

# tissuep: the path of issue folder {{{
tissuep () {
  echo $_tproject_issue_root/`tmuxsn`
}
# }}} tissuep

# tsrcp: the path of src folder {{{
tsrcp () {
  echo $_tproject_src_root/`tmuxsn`
}
# }}} tsrcp

# tj: tmux quick jump {{{
tj () {
  # without tmux, attach to a tmux session.
  if ! texist; then
    if [ "$#" -eq 0 ]; then
      tentry
    elif [ "$#" -eq 1 ]; then
      tattach $1
    else
      _perr "Do not support more than 1 argument.\n\n"
      _pmsg  "Usage:\n"
      _pmsg  "    $ tj\n"
      _pmsg  "    $ tj <project>\n"
      return -1;
    fi
    return 0;
  fi

    # jump to source directory.
    if [ "$#" -eq 0 ]; then
      cd `tsrcp`
    elif [ "$#" -eq 1 ]; then
      if [ $1 = "src" ]; then
        # jump to source directory.
        cd `tsrcp`
      elif [ $1 = "issue" ]; then
        # jump to issue directory.
        cd `tissuep`
      else
        # jump to another project.
        tattach $1
      fi
    else
      _perr "Do not support more than 1 argument.\n\n"
      _pmsg  "Usage:\n"
      _pmsg  "    $ tj\n"
      _pmsg  "    $ tj <src|issue>\n"
      _pmsg  "    $ tj <project>\n"
      return -1;
    fi
  }

_tj_complete () {
  if [ "$3" == "tj" ]; then
    COMPREPLY=( src issue `tprojectns` )
  fi
}

complete -F _tj_complete tj

# }}} tj

fi

#}}} utmux

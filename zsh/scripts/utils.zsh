#!/bin/zsh

# Document {{{
# @DOC
# # Utility Library
# A script supports useful commands.
#
# ## Insatll
# Create a symbolic link of `utils.zsh` under `~/.zsh`.
# ```bash
# ./install.sh
# ```
#
# ## Usage
# Add following code at the beginning of zsh scripts.
# ```zsh
# # Include utils.zsh {{{
# if [ -f ~/.zsh/utils.zsh ]; then
#   source ~/.zsh/utils.zsh
# else
#   printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
# fi
# # }}}
# ```
#
# ## Commands

# }}}

# Only include this file once.
if [[ -v __INCLUDE_UTILS_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_UTILS_ZSH__=1
fi

# Fix no command complete.
if [[ $SHELL == "/usr/bin/bash" ]]; then
  autoload -U +X bashcompinit && bashcompinit
  autoload -U +X compinit && compinit
elif [[ $SHELL == *zsh* ]]; then
  autoload -Uz compinit
  compinit
fi

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

# check_install: Check whether the binary exists. If not, install it by apt-get {{{
check_install () {
  for exe in "$@"; do
    if ! command -v $exe &> /dev/null; then
      prun sudo apt-get install -y $exe
    fi
  done
}

#}}} check_install

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

# prun: Print and run {{{
prun () {
  cmd="$@"
  pinfo "$ $cmd\n"
  eval "$cmd"
}
# }}} prun

# perror: Print error {{{
perror () {
  _red $1
}
#}}} perror

# pinfo: Print information {{{
pinfo () {
  _green $1
}
#}}} pinfo

# tmuxsn: Get current tmux session name {{{
tmuxsn () {
  session=$(tmux display-message -p '#S')
  echo "$session"
}
# }}} tmuxsn

#}}} uutils

# check-install {{{
check-install () {
  perror "check-install will be retired.\n"
  check_install $@
}

#}}} check-install

# _show_and_run {{{
_show_and_run () {
  perror "_show_and_run will be retired.\n"
  prun $@
}
# }}} _show_and_run

# _perr {{{
_perr () {
  perror "_perr will be retired.\n"
  _red $1
}
#}}} _perr

# _pinf {{{
_pinf () {
  perror "_pinf will be retired.\n"
  _green $1
}
#}}} _pinf

##> utmux: Utilities for tmux {{{
## tmuxsn: Show current tmux session name
##
## tmuxsns: Show all tmux session names
##
## tprojectns: Show all names of tmux projects
##
## tentry: Attach to session entry
##
## texist: Tmux checking
##   - Check whether using tmux
##     $ texist
##   - Check whether tmux session exists
##     $ texist [session name]
##
## tproject
##   - tinit [project]: initialize a new project
##
## tj: Quick jump
##
## tissuep: The path of issue folder
##
## tsrcp: The path of source folder
#
#if [[ -v TPROJECT_ENABLE ]]; then
#
## varialbes for tmux
#_tmux_entry_session_name=entry
#export _tproject_src_root=~/project
#export _tproject_issue_root=~/project
#
## tmuxsn {{{
#
#tmuxsn () {
#  session=$(tmux display-message -p '#S')
#  echo "$session"
#}
##}}} tmuxsn
#
## tmuxsns {{{
#tmuxsns () {
#  echo $(tmux ls | sed -r "s|([^ ]*):.*|\1|")
#}
##}}} tmuxsns
#
## tprojectns: show all tmux projects {{{
#tprojectns () {
#  ls $_tproject_src_root
#}
#
## }}} tprojectns
#
## tattach {{{
#
#tattach () {
#  if ! texist $1; then
#    # create a new session
#    tmux new -d -s $1
#
#    # move to src folder
#    tmux send-keys -t $1 "cd $_tproject_src_root/$1" ENTER
#  fi
#
#  # attach to the session
#  if texist; then
#    tmux switch -t $1
#  else
#    tmux attach -t $1
#  fi
#}
##}}}
#
## tentry {{{
#
#tentry () {
#  tattach $_tmux_entry_session_name
#}
##}}} tentry
#
## texist {{{
#
#texist () {
#  if [ "$#" -eq 1 ]; then
#    for sn in `tmuxsns`; do
#      if [[ "$sn" == "$1" ]]; then
#        return 0;
#      fi
#    done
#    return 1;
#  fi
#
#  if [[ -v TMUX ]]; then
#    return 0;
#  else
#    return 1;
#  fi
#}
##}}} texist
#
## tinit {{{
#
## hook function
#tinit_src_dir () {
#}
#
## hook function
#tinit_issue_dir () {
#}
#
#tinit () {
#  if [ "$#" -ne 1 ]; then
#    return 1;
#  fi
#
#  # initialize resources
#  srcp=$_tproject_src_root/$1
#  issuep=$_tproject_issue_root/$1
#  mkdir -p $srcp
#  mkdir -p $issuep
#  touch $issuep/note.md
#
#  # prepare tmux
#  tattach $1
#}
##}}} tinit
#
## tissuep: the path of issue folder {{{
#tissuep () {
#  echo $_tproject_issue_root/`tmuxsn`
#}
## }}} tissuep
#
## tsrcp: the path of src folder {{{
#tsrcp () {
#  echo $_tproject_src_root/`tmuxsn`
#}
## }}} tsrcp
#
## tj: tmux quick jump {{{
#
#_tj_error () {
#  _perr "tj format error!!!"
#  _pmsg  "Usage:\n"
#  _pmsg  "    $ tj\n"
#  _pmsg  "    $ tj <src | issue>\n"
#  _pmsg  "    $ tj <project> [src | issue]\n"
#}
#
#tj () {
#  # without tmux, attach to a tmux session.
#  if ! texist; then
#    if [ "$#" -eq 0 ]; then
#      tentry
#    elif [ "$#" -eq 1 ]; then
#      tattach $1
#    else
#      _tj_error
#      return -1
#    fi
#    return 0;
#  fi
#
#  # jump to source directory.
#  if [ "$#" -eq 0 ]; then
#    cd `tsrcp`
#
#  elif [ "$#" -eq 1 ]; then
#    if [ $1 = "src" ]; then
#      # jump to source directory.
#      cd `tsrcp`
#    elif [ $1 = "issue" ]; then
#      # jump to issue directory.
#      cd `tissuep`
#    else
#      # jump to another project.
#      tinit $1
#    fi
#
#  elif [ "$#" -eq 2 ]; then
#    for k in `tprojectns`; do
#      if [ $1 = $k ]; then
#        if [ $2 = "src" ]; then
#          cd $_tproject_src_root/$1
#        elif [ $2 = "issue" ]; then
#          cd $_tproject_issue_root/$1
#        else
#          _tj_error
#          return -1
#        fi
#        return 0
#      fi
#    done
#    _tj_error
#    return -1
#
#  else
#    _tj_error
#    return -1
#
#  fi
#}
#
#_tj_complete () {
#  if [ $3 = "tj" ]; then
#    COMPREPLY=( src issue `tprojectns` )
#  else
#    for k in `tprojectns`; do
#      if [ $3 = $k ]; then
#        COMPREPLY=( src issue )
#        return 0
#      fi
#    done
#  fi
#}
#
#complete -F _tj_complete tj
#
## }}} tj
#
#fi
#
##}}} utmux
#

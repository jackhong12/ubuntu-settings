#!/bin/bash

sudo apt-get update
sudo apt-get install zsh -y

distribution=`lsb_release -a 2> /dev/null | grep Description | sed 's|Description:[\t ]*||g'`

source ./zsh/lib/prun.zsh
source ./zsh/lib/cd.zsh
source ./zsh/lib/print.zsh
source ./zsh/lib/check_install.zsh

install () {
  _pushd $1

  echo "================================================================================"
  _green "INSTALL: $1\n"
  echo "================================================================================"
  zsh ./install.sh
  echo "--------------------------------------------------------------------------------"
  echo ""

  _popd
}

install zsh
install tmux
install fonts
install nvm
#install tools
#install tools/zsh-help

# git settings
prun check_install git
prun git config --global core.editor "vim"

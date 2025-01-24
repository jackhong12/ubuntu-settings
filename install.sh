#!/bin/bash

distribution=`lsb_release -a 2> /dev/null | grep Description | sed 's|Description:[\t ]*||g'`

source ./zsh/script/utils.zsh

install () {
  _pushd $1

  echo "================================================================================"
  _green "INSTALL: $1\n"
  echo "================================================================================"
  bash ./install.sh
  echo "--------------------------------------------------------------------------------"
  echo ""

  _popd
}

install zsh
install tmux
install fonts
install tools
install tools/zsh-help

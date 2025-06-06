#!/bin/zsh

# Usage:
#   - Analyze performance of a program using perf.
#     $ perf record -g ./your_program
#   - Show the recorded performance data.
#     $ perf report

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# perf_install_in_wsl2: Install perf in WSL2 {{{

perf_install_in_wsl2 () {
  root_folder=~/open-source
  mkdir -p $root_folder

  _pushd $root_folder
  if [ -d WSL2-Linux-Kernel ]; then
    _popd # $root_folder
    return 0
  fi

  check_install flex bison libpfm4-dev libtraceevent-dev pkg-config
  prun git clone https://github.com/microsoft/WSL2-Linux-Kernel --depth 1
  _pushd WSL2-Linux-Kernel/tools/perf
  prun make -j$(nproc)
  _popd # WSL2-Linux-Kernel/tools/perf
  _popd # $root_folder
}

# }}} perf_install_in_wsl2

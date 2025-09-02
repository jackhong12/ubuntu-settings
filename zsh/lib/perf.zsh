#!/bin/zsh

# Usage:
#   - Analyze performance of a program using perf.
#     $ perf record -g ./your_program
#   - Show the recorded performance data.
#     $ perf report

# Only include this file once {{{
if [[ -v __INCLUDE_PERF_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_PERF_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh

# perf_install_in_wsl2: Install perf in WSL2 {{{

perf_install_in_wsl2 () {
  root_folder=~/open-source
  mkdir -p $root_folder

  _pushd $root_folder
  if [ -d WSL2-Linux-Kernel ]; then
    _popd # $root_folder
    return 0
  fi

  check_install flex bison libpfm4-dev libtraceevent-dev pkg-config libslang2-dev libelf-dev
  prun git clone https://github.com/microsoft/WSL2-Linux-Kernel --depth 1
  _pushd WSL2-Linux-Kernel/tools/perf
  prun make -j$(nproc)
  mkdir -p ~/bin
  ln -sf `pwd`/perf ~/bin/perf
  _popd # WSL2-Linux-Kernel/tools/perf
  _popd # $root_folder
}

# }}} perf_install_in_wsl2

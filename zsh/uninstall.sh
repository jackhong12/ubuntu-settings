#!/bin/zsh

if [ ! -f ~/.zsh/zlib.zsh ]; then
  echo "zlib.zsh not found. Please run install.sh first."
  exit 0
fi

source ~/.zsh/zlib.zsh
zinclude "prun.zsh"

zlib_file=$(zlib_path)/zlib.zsh
prun git checkout $zlib_file
prun git update-index --no-assume-unchanged $zlib_file
prun rm -rf ~/.zsh/zlib.zsh
prun rm -rf ~/.zsh/zlib

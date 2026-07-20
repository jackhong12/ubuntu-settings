#!/bin/zsh

zinclude "prun.zsh"

SRC_DIR=gcc-dev

# - Clone code.
#   $ git clone git://gcc.gnu.org/git/gcc.git gcc-dev
# - Download Prerequistes
#   $ cd gcc-dev
#   $ ./contrib/download_prerequisites
# - Configure
#   $ cd ..
#   $ mkdir -p build_gdb
#   $ make CXXFLAGS="-g3 -O0"
gcc_src_configure () {
  prun \
    ../$SRC_DIR/configure \
    --prefix="`pwd`" \
    --disable-bootstrap \
    --enable-languages=c,c++ \
    STAGE1_C{,XX}FLAGS='"-O0 -g"'

}

# Useful Links:
#   - https://gcc.gnu.org/wiki/DebuggingGCC#gccbuilddebug

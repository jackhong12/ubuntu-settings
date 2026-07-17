#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_SPIRV_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_SPIRV_ZSH__=1
fi
# }}}

source ~/.zsh/zlib.zsh
zinclude "prun.zsh"

# cl_to_spirv: Compile and generate spv files {{{
cl_to_spirv () {
  if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]]; then
    echo "Usage: cl_to_spirv <file>"
    echo ""
    echo "Compile a .cl file to SPIR-V (.spv) via LLVM bitcode (.bc)."
    echo ""
    echo "Arguments:"
    echo "  <file>    Base name of the OpenCL source file (without .cl extension)"
    echo ""
    echo "Steps:"
    echo "  1. clang-17: <file>.cl -> <file>.bc  (LLVM bitcode, OpenCL 3.0, spir64)"
    echo "  2. llvm-spirv-17: <file>.bc -> <file>.spv"
    return 0
  fi
  local file=$1
  clang_bin="/usr/bin/clang-17"
  spirv_bin="llvm-spirv-17"
  prun "${clang_bin} -O0 -emit-llvm -c ${file}.cl -o ${file}.bc -cl-std=CL3.0 -target spir64"
  prun "${spirv_bin} ${file}.bc -o ${file}.spv"
}
# }}} cl_to_spirv

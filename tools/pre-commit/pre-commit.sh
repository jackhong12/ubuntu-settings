#!/bin/sh
ROOT=$(git rev-parse --show-toplevel)
COMMIT_PATH=$ROOT/tools/pre-commit
tmp_path=`pwd`

cd $COMMIT_PATH
bash -x remove_rp.zsh
cd $tmp_path

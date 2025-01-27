#!/bin/zsh

source ../../zsh/scripts/utils.zsh

ROOT=$(git-root)
_pushd $ROOT

staged_files=$(git diff --name-only --cached --diff-filter=AM)
# remove private variables
for f in $staged_files; do
  zsh-remove-path $f
  git add $f
done

_popd

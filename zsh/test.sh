#!/bin/zsh

script_dir=${0:A:h}

for f in $script_dir/test/**/*.zunit(N); do
  echo "=== $f ==="
  zunit "$f"
done

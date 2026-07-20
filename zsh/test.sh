#!/bin/zsh

for f in test/**/*.zunit(N); do
  echo "=== $f ==="
  zunit "$f"
done

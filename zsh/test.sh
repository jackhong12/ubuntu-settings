#!/bin/zsh

for f in test/**/*.zunit(N); do
  zunit "$f"
done

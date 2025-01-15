#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# Link all *.zsh files
mkdir -p ~/.zsh
for f in *.zsh; do
    prun ln -sf `pwd`/$f ~/.zsh
done

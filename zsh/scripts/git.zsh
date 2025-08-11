#!/bin/zsh

# Create a new branch
#   $ git checkout -b <branch>
# Switch to a branch
#   $ git checkout <branch>
# Avoid tracking files
#   $ git update-index --assume-unchanged <file>
# Change the commit message without modifying the content
#   $ git commit --amend

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

git-log-pretty () {
  git log --graph --decorate --pretty=format:"%C(auto)%h %Cblue%cd%C(auto)%d %s %Cgreen%an" --date=format:"%m/%d" $@
}

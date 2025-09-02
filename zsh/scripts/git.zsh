#!/bin/zsh

# Only include this file once {{{
if [[ -v __INCLUDE_GIT_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_GIT_ZSH__=1
fi
# }}}

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

# git-log-pretty: Pretty git log with graph, colors, and decorations {{{
git-log-pretty () {
  git log --all --graph --decorate --pretty=format:"%C(auto)%h %Cblue%cd%C(auto)%d %s %Cgreen%an" --date=format:"%m/%d" $@
}
# }}} git-log-pretty

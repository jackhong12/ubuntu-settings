#!/bin/zsh

# Create a new branch
#   $ git checkout -b <branch>
# Switch to a branch
#   $ git checkout <branch>
# Avoid tracking files
#   $ git update-index --assume-unchanged <file>
# Change the commit message without modifying the content
#   $ git commit --amend

# Only include this file once {{{
if [[ -v __INCLUDE_GIT_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_GIT_ZSH__=1
fi
# }}}

# git-log-pretty: Pretty git log with graph, colors, and decorations {{{
git-log-pretty () {
  git log --all --graph --decorate --pretty=format:"%C(auto)%h %Cblue%cd%C(auto)%d %s %Cgreen%an" --date=format:"%m/%d" $@
}
# }}} git-log-pretty

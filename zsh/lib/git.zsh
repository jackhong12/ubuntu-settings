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

# git-log-pretty: Pretty git log with graph, colors, and decorations {{{
git-log-pretty () {
  git log --all --graph --decorate --pretty=format:"%C(auto)%h %Cblue%cd%C(auto)%d %s %Cgreen%an" --date=format:"%m/%d" $@
}
# }}} git-log-pretty

# git-log-pretty-oneline: Pretty git log with graph, colors, and decorations {{{
git-log-pretty-oneline () {
  git log --graph --decorate --pretty=format:"%C(auto)%h %Cblue%cd%C(auto)%d %s %Cgreen%an" --date=format:"%m/%d" $@
}
# }}} git-log-pretty

# git_is: Whether under a git repo {{{
git_is () {
  git status > /dev/null 2>&1
  return $?
}

# }}} git_is

# git_root: Get the root path of a git repo {{{
git_root () {
  root=$(git rev-parse --show-toplevel 2> /dev/null )
  if [ $? -eq 0 ]; then
    echo $root
    return 0
  fi
  return -1
}

#}}} git_root

# git_branch_name: Get the current branch name {{{
git_branch_name () {
  git_root=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [ $? -eq 0 ]; then
    echo $git_root
    return 0
  fi
  return -1
}

# }}} git_branch_name

# zgit-show-previous-modified-files: Show previously modified files in the last commit {{{

zgit-show-previous-modified-files () {
  if ! git_is; then
    echo "Not a git repository"
    return -1
  fi
  files=$(git diff-tree --no-commit-id --name-only -r HEAD)
  echo $files
  return 0
}

# }}} zgit-show-previous-modified-files

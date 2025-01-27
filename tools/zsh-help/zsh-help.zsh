#> zh: Show zsh document {{{
# Show all categories
#   $ zh
#
# Show document
#   $ zh [category]

source ~/.zsh/utils.zsh

__rp_root=/home/jack/ubuntu-settings
SCRIPT=$__rp_root/tools/zsh-help/zsh_help.py

# zh: show help {{{

zh () {
  if [ "$#" -eq 1 ]; then
    python3 $SCRIPT -d ~/.zsh ~/.zshrc $1
  else
    python3 $SCRIPT -d ~/.zsh ~/.zshrc
  fi
}

_zh_keywords () {
  echo $(zh | _color_remove | sed "s|:.*||g")
}

_zh_complete () {
  COMPREPLY=( $(compgen -W "$(_zh_keywords)" -- "$2") )
}
complete -F _zh_complete zh

#}}} zh

#}}} zh

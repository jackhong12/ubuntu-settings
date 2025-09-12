
# Only include this file once {{{
if [[ -v __INCLUDE_YES_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_YES_CTAGS__=1
fi
# }}}

check_yes () {
  while true; do
    printf "Do you want to continue? (y/n): "
    read yn
    if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
      return 0
    elif [[ "$yn" == "n" || "$yn" == "N" ]]; then
      return 1
    else
      echo "Please answer y or n."
    fi
  done
}

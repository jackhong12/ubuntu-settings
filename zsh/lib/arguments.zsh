
# Only include this file once {{{
if [[ -v __INCLUDE_ARGUMENTS_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_ARGUMENTS_CTAGS__=1
fi
# }}}

source ~/.zsh/zlib
zinclude "print.zsh"

# Usage:
#   if check_arguments "-test" "$@"; then
#     echo "Test argument found"
#   fi
check_arguments() {
  if [ "$#" -lt 1 ]; then
    perror "Usage: $0 <targets> [arguments]\n"
    return 1
  fi

  for arg in "${@:2}"; do
    if [[ "$arg" == "$1" ]]; then
      return 0
    fi
  done

  return 1
}

# Usage:
#   if optin=$(get_arguments "-option" "default_value" "$@"); then
#     echo "Option value: $optin"
#   fi
get_arguments () {
  if [ "$#" -lt 2 ]; then
    perror "Usage: $0 <target> <default> [arguments]\n"
    return 1
  fi

  default="$2"
  match="$1=*"
  for arg in "${@:3}"; do
    if [[ "$arg" == $1=* ]]; then
      default="${arg#*=}"
      echo $default
      return 0
    fi
  done

  echo "$default"
  return 1
}

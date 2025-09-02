
# Only include this file once {{{
if [[ -v __INCLUDE_PYTHON_ZSH__ ]]; then
  return 0;
else
  __INCLUDE_PYTHON_ZSH__=1
fi
# }}}

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

py_default_name="venv"

# py_venv_init: Initialize Python virtual environment {{{
py_venv_init() {
  # Check if Python is installed and version is 3.12
  if ! command -v python3 &> /dev/null; then
    perror "\033[0;31mPython 3 is not installed.\033[0m\n"
    return 1
  fi
  if ! python3 --version | grep -q "Python 3.12"; then
    perror "\033[0;31mPython version is not 3.12.\033[0m\n"
    return 1
  fi
  python3 -m venv $py_default_name
}
# }}} py_venv_init

# py_venv_activate: Activate Python virtual environment {{{
py_venv_activate() {
  # Check if the virtual environment directory exists
  if [ ! -d "$py_default_name" ]; then
    perror "\033[0;31mVirtual environment '$py_default_name' does not exist.\033[0m\n"
    return 1
  fi

  # Activate the virtual environment
  source "$py_default_name/bin/activate"

  # Check if activation was successful
  if [ $? -ne 0 ]; then
    perror "\033[0;31mFailed to activate virtual environment.\033[0m\n"
    return 1
  fi

  echo "Virtual environment '$py_default_name' activated."
}
# }}} py_venv_activate

# py_venv_deactivate: Deactivate Python virtual environment {{{
py_venv_deactivate() {
  # Check if the virtual environment is activated
  if [ -z "$VIRTUAL_ENV" ]; then
    perror "\033[0;31mNo virtual environment is currently activated.\033[0m\n"
    return 1
  fi

  # Deactivate the virtual environment
  deactivate

  # Check if deactivation was successful
  if [ $? -ne 0 ]; then
    perror "\033[0;31mFailed to deactivate virtual environment.\033[0m\n"
    return 1
  fi

  echo "Virtual environment '$py_default_name' deactivated."
}

# }}} py_venv_deactivate

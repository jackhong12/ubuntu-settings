# utils

## Install
Install this script by following command. It will make a symbolic link of `utils.zsh` under `~/.zsh`.

```zsh
$ ./install.sh
```

## Usage
Utilities for zsh shell.
```zsh
# Include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}}
```

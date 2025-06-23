# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Basic Alias {{{
export TZ='Asia/Taipei'
export TERM="xterm-256color"
#export CC="clang"
#export CXX="clang++"
#export LD="LLD"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#}}} Basic Alias

# OMZ {{{
ZSH_THEME="powerlevel10k/powerlevel10k"

export ZSH="$HOME/.oh-my-zsh"
plugins=(
    vi-mode
    history
    colored-man-pages
    colorize
    web-search
    dirhistory
    extract

    # other plugins
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    git
)

source $ZSH/oh-my-zsh.sh

bindkey '^O' autosuggest-accept	# bind autocompelet

# update option
DISABLE_AUTO_UPDATE="true"

#}}} OMZ

#> key: Zsh Key Mapping {{{
# Show all bind keys
# - <ctrl> + h: backspace
# - <ctrl> + w: kill word
# - <ctrl> + b: begin of line
# - <ctrl> + e: end of line
# - <ctrl> + j: backward a word
# - <ctrl> + k: forward a word

bindkey '^H' backward-delete-char
bindkey '^W' kill-word

bindkey '^B' beginning-of-line
bindkey '^E' end-of-line

bindkey '^J' backward-word
bindkey '^K' forward-word

#}}} key

# enable tproject
export TPROJECT_ENABLE=1

# Include utils.zsh first {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}}

# Include Other Files in ~/.zsh {{{
if [ -d ~/.zsh ]; then
  zsh_files=($(find -L ~/.zsh -type f -name "*.zsh"))
  for file in "${zsh_files[@]}"; do
    source $file
  done
fi
#}}} Include other files

# Add ~/bin to PATH {{{
export PATH="$HOME/bin:$PATH"
# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# P10k Settings {{{
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=
#}}} P10k settings

eval "$(zoxide init zsh)"

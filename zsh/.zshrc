# basic settings
export TZ='Asia/Taipei'
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# oh-my-zsh settins
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="$HOME/.oh-my-zsh"
plugins=(
    git
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
)

source $ZSH/oh-my-zsh.sh

# bind autocompelet
bindkey '^O' autosuggest-accept

# update option
DISABLE_AUTO_UPDATE="true"

# key mapping {{{

# - show all bind keys
#     bindkey

bindkey '^H' backward-delete-char
bindkey '^W' kill-word

bindkey '^B' beginning-of-line
bindkey '^E' end-of-line

bindkey '^J' backward-word
bindkey '^K' forward-word

#}}}

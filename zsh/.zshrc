# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Basic Alias {{{
export TZ='Asia/Taipei'
export TERM="xterm-256color"
export CC="clang"
export CXX="clang++"
export LD="LLD"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# }}}
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
)

source $ZSH/oh-my-zsh.sh

bindkey '^O' autosuggest-accept	# bind autocompelet

# update option
DISABLE_AUTO_UPDATE="true"

# }}}
# Key Mapping {{{

# - show all bind keys
#     bindkey

bindkey '^H' backward-delete-char
bindkey '^W' kill-word

bindkey '^B' beginning-of-line
bindkey '^E' end-of-line

bindkey '^J' backward-word
bindkey '^K' forward-word

#}}}
# Include Other Files in ~/.zsh {{{
if [ -d ~/.zsh ]; then
    c=$(ls ~/.zsh | wc -c)
    if [ $c -gt 0 ]; then
        for f in ~/.zsh/*.zsh; do
            source $f
        done
    fi
fi

# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# P10k Settings {{{
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=

# }}}

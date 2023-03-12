#!/bin/bash

distribution=`lsb_release -a 2> /dev/null | grep Description | sed 's|Description:[\t ]*||g'`

pushd zsh
bash -x ./install.sh
popd

pushd tmux
bash -x ./install.sh
popd

# install nerd fonts
if [[ $distribution = 'Ubuntu 22.04.'*'LTS' ]] || [[ $distribution = 'Ubuntu 22.04.'*'LTS' ]]; then
    if [ ! -f ~/.fonts/'Ubuntu Mono Nerd Font Complete Mono.ttf' ]; then
        wget -P ~/.fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
    fi
    printf "\033[0;34mChange terminal fonts: \n"
    printf "    Preferences > Unamed > Custom font > UbuntuMono Nerd Font Mono\033[0m\n"
else
    echo "Install fonts from https://github.com/ryanoasis/nerd-fonts"
fi

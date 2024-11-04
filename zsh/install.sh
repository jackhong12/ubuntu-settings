#!/bin/bash

source ../tools/utils.zsh

check-install git zsh wget curl powerline autojump locales

# gen en_US.UTF-8
sudo locale-gen en_US.UTF-8

# install .oh-my-zsh
if [ ! -d ${HOME}/.oh-my-zsh ]; then
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O /tmp/install.sh
    sh /tmp/install.sh
fi

# install zsh-syntax-highlight
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# install zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# install p10k theme
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/theme/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

ln -sf `pwd`/.zshrc ~/.zshrc

sudo chsh -s $(which zsh)

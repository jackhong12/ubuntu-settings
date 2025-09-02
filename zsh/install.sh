#!/bin/zsh

source ./lib/check_install.zsh
source ./lib/prun.zsh

prun check_install git zsh wget curl powerline autojump locales fzf zoxide

# gen en_US.UTF-8
prun sudo locale-gen en_US.UTF-8

# install .oh-my-zsh
if [ ! -d ${HOME}/.oh-my-zsh ]; then
    prun wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O /tmp/install.sh
    prun sh /tmp/install.sh
fi

# install zsh-syntax-highlight
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    prun git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# install zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    prun git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# install p10k theme
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    prun git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

prun ln -sf `pwd`/.zshrc ~/.zshrc

prun sudo chsh -s $(which zsh)

rm -rf ~/.zsh/zlib
zlib_path="$(realpath ~/.zsh/zlib)"

# var_init: Initialize value in zlib {{{
var_init () {
  # Change the variable in zlib.zsh
  local file=lib/zlib.zsh
  local git_root_path=$(git rev-parse --show-toplevel)

  prun git checkout $file

  sed -i "s|__SED_UBUNTU_SETTINGS_GIT_ROOT__|$git_root_path|g" $file
  sed -i "s|__SED_USETTING_ZSH_LIB_PATH__|$zlib_path|g" $file

  prun git update-index --assume-unchanged $file

  printf "Set Env:\n"
  printf "  __UBUNTU_SETTINGS_GIT_ROOT__: $git_root_path\n"
  printf "  __USETTING_ZSH_LIB_PATH__:    $zlib_path\n"
}
# }}} var_init

# Change default variables.
var_init

# Link all zsh scripts.
mkdir -p ~/.zsh
prun ln -sf `pwd`/lib/zlib.zsh ~/.zsh/zlib.zsh
prun ln -sf `pwd`/lib/ $zlib_path

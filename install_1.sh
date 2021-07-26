#! /bin/bash
set -e

# add neovim repo
sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update && sudo apt upgrade -y

# install apt packages
sudo apt install -y neovim zsh tmux curl fzf libjpeg8-dev zlib1g-dev python-dev \
python3-dev libxtst-dev python3-pip libxft-dev make xorg xcape mlocate apt-transport-https \
pkg-config libharfbuzz-dev xorg openbox bluez bluez-tools pavucontrol htop \
wget stow chromium-browser i3 fonts-symbola flameshot laptop-mode-tools

# install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

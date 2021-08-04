#! /bin/bash
set -e

# add neovim repo
sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update && sudo apt upgrade -y

# install apt packages
sudo apt install -y neovim zsh tmux curl libjpeg8-dev zlib1g-dev python-dev \
python3-dev libxtst-dev python3-pip libxft-dev make xorg xcape mlocate apt-transport-https \
pkg-config libharfbuzz-dev xorg openbox bluez bluez-tools blueman pavucontrol htop xclip \
wget stow chromium-browser i3 fonts-symbola flameshot laptop-mode-tools i3lock

# install fzf from source for latest version
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

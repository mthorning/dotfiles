#! /bin/bash
set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

cd $HOME

# add neovim repo
sudo add-apt-repository ppa:neovim-ppa/unstable

apt update && apt upgrade

# install basic packages
apt install neovim curl fzf libjpeg8-dev zlib1g-dev python-dev \
python3-dev libxtst-dev python3-pip tmux libxft-dev make xorg \
xorg-server xorg-xinit pkg-config libharfbuzz-dev xorg openbox \
bluez bluez-tools pavucontrol wget stow chromium-browser i3

# fonts
apt install fonts-symbola
wget "https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip?_gl=1*1hl7zfl*_ga*MTYyNjM3ODMzMS4xNjI2Njc2OTU0*_ga_V0XZL7QHEB*MTYyNzA3NTkzNi4yLjAuMTYyNzA3NTk0MS4w" -O jetbrains.zip
unzip jetbrains.zip
mv fonts/ttf /usr/share/fonts/truetype/jetbrains-mono
rm jetbrains.zip fonts

wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
mv 'JetBrains Mono Regular Nerd Font Complete Mono.ttf' /usr/share/fonts/truetype/jetbrains-mono/JetBrains-Mono-Regular-Nerd-Font-Complete-Mono.ttf
fc-cache -f -v

#install languages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install ripgrep
cargo install ripgrep

# install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# install ST
g clone git@github.com:mthorning/terminal.git
cd terminal.git
make install
cd $HOME

# install pip3 packages
pip3 install ueberzug
pip3 install neovim-remote
pip3 install pynvim --user

# install npm packages
npm install -g prettier tree-sitter-cli eslint_d

# packer for nvim
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# for acer display (will need to be changed for different monitors)
xrandr --output DP-1-1 --primary --left-of eDP-1
echo  "xrandr --output DP-1-1 --primary --left-of eDP-1" >> /etc/X11/Xsession.d/45custom_xrandr-settings 

# install joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# music
snap install youtube-music-desktop-app

cd $HOME/dotfiles
stow main
stow home

source ~/.zshrc


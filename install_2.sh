#! /bin/bash
set -e

# starship prompt
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
sudo dpkg -i ripgrep_12.1.1_amd64.deb


# fonts
wget "https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip?_gl=1*1hl7zfl*_ga*MTYyNjM3ODMzMS4xNjI2Njc2OTU0*_ga_V0XZL7QHEB*MTYyNzA3NTkzNi4yLjAuMTYyNzA3NTk0MS4w" -O jetbrains.zip
unzip jetbrains.zip
sudo mv fonts/ttf /usr/share/fonts/truetype/jetbrains-mono
rm -rf jetbrains.zip fonts

wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
sudo mv 'JetBrains Mono Regular Nerd Font Complete Mono.ttf' /usr/share/fonts/truetype/jetbrains-mono/JetBrains-Mono-Regular-Nerd-Font-Complete-Mono.ttf
fc-cache -f -v

#install languages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

wget "https://golang.org/dl/go1.16.6.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz
rm go1.16.6.linux-amd64.tar.gz

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install --lts
nvm use --lts

# install ST
git clone https://github.com/mthorning/terminal.git
cd terminal
sudo make install
cd ..
rm -rf terminal

# install pip3 packages
pip3 install ueberzug
pip3 install neovim-remote
pip3 install pynvim --user

# install npm packages
npm install -g prettier tree-sitter-cli eslint_d

# install joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# music
sudo snap install youtube-music-desktop-app

rm ~/.zshrc
cd $HOME/dotfiles
stow main
stow home
git checkout . && git clean -fd

reboot

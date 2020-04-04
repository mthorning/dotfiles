pacman -Syu
pacman -S git which sudo zsh base-devel exa ripgrep fzy

# zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
zsh


# tmux

# nvim

# as user
useradd mthorning
su mthorning
cd

git clone https://aur.archlinux.org/yay-git.git
sudo chown -R mthorning:mthorning ./yay-git
cd yay-git
makepkg -si

# nvm and space-ship prompt
yay -S nvm
[ -z "NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
nvm install --lts
nvm use --lts
npm i -g spaceship-prompt

git clone https://github.com/mthorning/dotfiles.git
echo source ~/dotfiles/.zshrc >> ~/.zshrc
source ~/.zshrc


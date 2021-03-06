# dotfiles
A place for my configuration files so that I can easily access them from other computers.

## Installation Notes

### ZSH
* Install ZShell from package manager. Don't link .zshrc immediately! Test first by sourcing ~/dotfile/.zshrc.
* Oh-my-zsh `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
* Install [starship](https://github.com/starship/starship)

### Neovim
* Install Neovim from package manager and Python 2 & 3: https://github.com/neovim/neovim/wiki/Installing-Neovim
* In nvim: `:checkhealth`: Need to install pynvim for both python 2 & 3.
* VimPlug: ` curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

### Misc
* Install NVM `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash`
* Install fzy, exa and ripgrep with package manager.
* [Alacritty fork with ligatures](https://github.com/zenixls2/alacritty/tree/ligature)

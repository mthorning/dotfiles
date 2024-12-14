{ pkgs, home, ... }:
  let
    homeDir = builtins.getEnv "HOME";
  in {
    home = {
      packages = with pkgs; [
        git
        neovim
        tmux
        zsh
        fzf
        gnused
        fd
        lazygit
        ripgrep
        bat
        lsd
        yazi
        git-machete
        tldr
        wget
      ];
  
      file."${homeDir}/.tmux.conf" = { source = ./tmux.conf; };
      file."${homeDir}/.zshrc" = { source = ./zshrc; };
      file."${homeDir}/.local/bin" = { source = ./bin; recursive = true; };
      file."${homeDir}/.config/yazi" = { source = ./yazi; recursive = true; };
      file."${homeDir}/.config/nvim" = { source = ./nvim; recursive = true; };
      file."${homeDir}/.config/lazygit" = { source = ./lazygit; recursive = true; };
      file."${homeDir}/.config/kitty" = { source = ./kitty; recursive = true; };
    };
    xdg.enable = true;
    programs.home-manager.enable = true;
}

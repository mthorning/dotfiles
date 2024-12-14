{ pkgs, ... }: 
let
  homeDir = builtins.getEnv "HOME";
in {
  home = {
    stateVersion = "23.11";
    username = "mattthorning";
    homeDirectory = "/Users/mattthorning";

    packages = with pkgs; [
      gh
    ];

    file."${homeDir}/.zshrc" = { source = ./zshrc-work; };
  };
}

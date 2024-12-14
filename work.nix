{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    username = "mattthorning";
    homeDirectory = "/Users/mattthorning";

    packages = with pkgs; [
      gh
    ];

  };
}

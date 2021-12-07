{ ... }: {
  imports = [
    ./direnv.nix
    ./fish.nix
    ./font.nix
    ./git.nix
    ./pkg.nix
    ./starship.nix
    ./vscode
  ];

  home.stateVersion = "21.05";
  programs.home-manager.enable = true;
}

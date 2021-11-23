{ pkgs, lib, config, ... }: {
  imports = [
    ./direnv.nix
    ./fish.nix
    ./font.nix
    ./git.nix
    ./pkg.nix
    ./starship.nix
    ./vscode.nix
  ];

  home.stateVersion = "21.05";
  programs.home-manager.enable = true;
}

{ pkgs, lib, system, ... }:
let
  packages = with pkgs; [
    # Dev tools
    git # Version control
    vim # Command line text editor
    docker-compose # Container orchestration for Docker.

    # Languages
    ## Rust
    fenix.rust-analyzer # Rust language server.

    ## Nix
    rnix-lsp # Nix language server

    # Utilities
    htop # Interactive proccess viewer
    wally-cli # Firmware flasher for ZSA keyboards
  ];
  macosPackages = with pkgs; [ ];
  nixosPackages = with pkgs; [
    _1password-gui # Password manager
  ];
in
{
  home.packages = packages
    ++ lib.optionals pkgs.stdenv.isDarwin macosPackages
    ++ lib.optionals pkgs.stdenv.isLinux nixosPackages;
}

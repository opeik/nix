# Additional macOS home-manager features implemented as optional modules
{ ... }: {
  imports = [
    ./alias-apps.nix
    ./shell.nix
    ./terminal.nix
  ];
}

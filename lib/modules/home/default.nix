# Additional home-manager features implemented as optional modules
{ ... }: {
  imports = [
    ./manage-apps.nix
    ./shell.nix
    ./terminal.nix
    ./vim.nix
  ];
}

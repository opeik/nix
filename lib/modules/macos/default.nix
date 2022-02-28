# Additional nix-darwin features implemented as optional modules
{ ... }: {
  imports = [
    ./pam.nix
  ];
}

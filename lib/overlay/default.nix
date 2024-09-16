# Additional Nix package overlays, see: https://nixos.org/manual/nixpkgs/stable/#chap-overlays
{nixpkgs-unstable}: {
  overlays = [(import ./unstable.nix {inherit nixpkgs-unstable;})];
}

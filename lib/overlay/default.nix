# Additional Nix package overlays, see: https://nixos.org/manual/nixpkgs/stable/#chap-overlays
{unstable}: [
  (import ./unstable.nix {inherit unstable;})
]

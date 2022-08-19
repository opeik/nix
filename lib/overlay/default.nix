# Additional package overlays
{ unstable }: [
  (import ./macos-apps.nix)
  (import ./unstable.nix { inherit unstable; })
]

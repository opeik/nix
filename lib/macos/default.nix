# Custom macOS (nix-darwin) modules.
{...}: {
  imports = [
    ./pam.nix
  ];
}

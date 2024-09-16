# nixpkgs unstable package overlay.
{nixpkgs-unstable}: final: prev: {
  unstable = import nixpkgs-unstable {
    system = prev.system; # Use the system's architecture
    config.allowUnfree = true; # Enable proprietary packages
  };
}

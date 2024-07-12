# macOS (nix-darwin) config, see: https://lnl7.github.io/nix-darwin/manual
{
  flake-inputs,
  pkgs,
  lib,
  config,
  root,
  ...
}: {
  imports = ["${root}/lib/macos"]; # Import macOS modules
  system.stateVersion = 4; # nix-darwin version, do not touch
  services.nix-daemon.enable = true; # Enable the Nix build daemon
  nixpkgs.config.allowUnfree = true; # Enable proprietary packages
  system.activationScripts.applications.text = lib.mkForce ""; # Disable nix-darwin ~/Applications management
  users.users.${config.username}.home = config.home; # Define system user

  nix = {
    package = pkgs.nixVersions.latest; # Use the latest Nix version.
    extraOptions = ''
      experimental-features = flakes nix-command # Enable flakes and the new cli
      keep-derivations = true # Keep derivations to speed up direnv
      keep-outputs = true # Keep derivation outputs to speed up direnv
    '';
    registry.nixpkgs.flake = flake-inputs.nixpkgs; # Pin `nixpkgs` to the system version
  };

  # Enable Nix integration with the default shell (zsh) as a fallback in case something goes haywire.
  programs.zsh.enable = true;

  # Setup home-manager, which manages your user
  home-manager = {
    useGlobalPkgs = true; # Use the system's nixpkgs
    useUserPackages = true; # Enable user-local packages
    sharedModules = [./home-manager.nix "${root}/lib/home-manager/macos"]; # Shared modules for all users
    extraSpecialArgs = {inherit root;}; # Provide the flake root directory to home-manager modules
  };
}

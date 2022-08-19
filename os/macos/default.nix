# macOS (nix-darwin) configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{ flake-inputs, pkgs, lib, config, root, ... }: {
  imports = [ "${root}/lib/macos" "${root}/src/macos" ]; # Import macOS modules
  system.stateVersion = 4; # nix-darwin version, do not touch
  services.nix-daemon.enable = true; # Enable the Nix build daemon
  nixpkgs.config.allowUnfree = true; # Enable proprietary packages
  system.activationScripts.applications.text = lib.mkForce ""; # Disable nix-darwin ~/Applications management
  users.users.${config.username}.home = config.home; # Define system user

  # Use the nix-community binary cache to speed up builds
  cachix = [{ name = "nix-community"; sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g"; }];

  nix = {
    package = pkgs.nixVersions.nix_2_9; # Use the latest Nix version.
    extraOptions = ''
      experimental-features = flakes nix-command # Enable flakes and the new cli
      keep-derivations = true # Keep derivations to speed up direnv
      keep-outputs = true # Keep derivation outputs to speed up direnv
    '';
    registry.nixpkgs.flake = flake-inputs.nixpkgs; # Pin `nixpkgs` to the system version
  };

  programs = {
    fish.enable = true; # Enable fish support
    zsh.enable = true; # Enable zsh support
  };

  # Setup home-manager, which manages your user
  home-manager = {
    useGlobalPkgs = true; # Use the system's nixpkgs
    useUserPackages = true; # Enable user-local packages
    sharedModules = [ ./home.nix "${root}/lib/home" "${root}/lib/home/macos" ]; # Shared modules for all users
    extraSpecialArgs = { inherit root; }; # Provide the flake root directory to home-manager modules
  };
}

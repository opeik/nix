# nix-darwin configuration, see: <https://lnl7.github.io/nix-darwin/manual/index.html>
{ pkgs, config, ... }: {
  imports = [ ../modules/macos ]; # Import macOS modules
  system.stateVersion = 4; # nix-darwin version, do not touch
  services.nix-daemon.enable = true; # Enable the Nix build daemon
  nixpkgs.config.allowUnfree = true; # Enable proprietary packages
  system.activationScripts.applications.text = pkgs.lib.mkForce ""; # Disable nix-darwin ~/Applications management

  # Use the nix-community binary cache to speed up builds
  cachix = [{ name = "nix-community"; sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g"; }];

  nix = {
    package = pkgs.nix_2_4; # Use Nix 2.4 for flake support
    extraOptions = ''
      experimental-features = flakes nix-command # Enable flakes and the new cli
      # Use more storage to speed up direnv
      keep-derivations = true
      keep-outputs = true
    '';
  };

  programs = {
    fish.enable = true; # Enable fish support
    zsh.enable = true; # Enable zsh support
  };

  # Setup `home-manager`, which manages your home environment
  home-manager = {
    useGlobalPkgs = true; # Use the system's nixpkgs
    useUserPackages = true; # Enable user-local packages
    sharedModules = [ ./home.nix ../modules/home ]; # Shared modules for all users
  };
}

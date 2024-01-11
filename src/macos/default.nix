# macOS (nix-darwin) configuration, see: <https://lnl7.github.io/nix-darwin/manual>
{
  flake-inputs,
  pkgs,
  lib,
  config,
  root,
  ...
}: let
  nixos-rebuild = pkgs.writeShellScriptBin "nixos-rebuild" ''
    main() {
      local target="$1"

      if [ -z "$target" ]; then
        local user="$(whoami)"
        local host="$(hostname)"
        local system="$(nix eval --impure --raw --expr 'builtins.currentSystem')"
        target="$user-$host-$system"
      fi

      cd /Users/${config.username}/Development/nix
      nix build ".#darwinConfigurations.$target.system"
      ./result/sw/bin/darwin-rebuild switch --flake ".#$target"
    }

    main "$1"
  '';
in {
  imports = ["${root}/lib/macos"]; # Import macOS modules
  system.stateVersion = 4; # nix-darwin version, do not touch
  services.nix-daemon.enable = true; # Enable the Nix build daemon
  nixpkgs.config.allowUnfree = true; # Enable proprietary packages
  system.activationScripts.applications.text = lib.mkForce ""; # Disable nix-darwin ~/Applications management
  users.users.${config.username}.home = config.home; # Define system user

  # Use the nix-community binary cache to speed up builds
  cachix = [
    {
      name = "nix-community";
      sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x";
    }
  ];

  nix = {
    package = pkgs.nixVersions.stable; # Use the latest Nix version.
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
    sharedModules = [./home-manager.nix "${root}/lib/home-manager/macos"]; # Shared modules for all users
    extraSpecialArgs = {inherit root;}; # Provide the flake root directory to home-manager modules
  };

  environment = {
    systemPackages = [nixos-rebuild pkgs.nushell];
    shells = with pkgs; [fish nushell];
  };
}

# Nix flake, see: <https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html>
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11"; # Nix packages
    unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix unstable packages
    cachix.url = "github:jonascarpay/declarative-cachix"; # Cachix support, a Nix binary cache
    # macOS support
    nix-darwin = { url = "github:lnl7/nix-darwin"; inputs.nixpkgs.follows = "nixpkgs"; };
    # User environment management
    home-manager = { url = "github:nix-community/home-manager/release-21.11"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, unstable, cachix, nix-darwin, home-manager, ... }:
    let
      # Load config from `./config.toml`
      config = (builtins.fromTOML (builtins.readFile ./config.toml));
      # Shared nixOS and macOS modules
      sharedModules = [ ./lib/options.nix config overlays cachix.nixosModules.declarative-cachix ] ++ [{
        users.users.${config.user.username}.home = config.user.home; # Define system user
        home-manager.users.${config.user.username}.imports = [ ./src/home ]; # Import home-manager user
      }];
      # macOS specific modules
      macosModules = [ ./lib/macos ./src/macos home-manager.darwinModules.home-manager ] ++ [{
        home-manager.users.${config.user.username}.imports = [ ./src/home/macos ]; # Import macOS home-manager user
      }];
      # Package overlays
      overlays.nixpkgs.overlays = [ unstableOverlay ];
      # Unstable package overlay; accessible via `pkgs.unstable`
      unstableOverlay = final: prev: {
        unstable = import unstable {
          system = prev.system; # Use the system's architecture
          config.allowUnfree = true; # Enable proprietary packages
        };
      };
      # Returns a new macOS configuration
      newMacosConfig = { system, modules ? [ ] }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = modules ++ macosModules ++ sharedModules;
        };
    in
    {
      darwinConfigurations = {
        reimu = newMacosConfig { system = "aarch64-darwin"; modules = [{ networking.hostName = "reimu"; }]; };
        reimu-ci = newMacosConfig { system = "x86_64-darwin"; modules = [{ networking.hostName = "reimu-ci"; }]; };
      };
    };
}

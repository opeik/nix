# Nix flake, see: <https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake>
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin"; # Nix packages
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix unstable packages
    cachix.url = "github:jonascarpay/declarative-cachix"; # Cachix support, a Nix binary cache
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # macOS support
    flake-utils.url = "github:numtide/flake-utils"; # Flake utils
    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = flake-inputs @ {
    self,
    nixpkgs,
    unstable,
    cachix,
    nix-darwin,
    home-manager,
    flake-utils,
    ...
  }: let
    # macOS and nixOS modules
    modules = {
      macos = [./os/macos home-manager.darwinModules.home-manager];
      shared = [./lib/options.nix overlays cachix.nixosModules.declarative-cachix];
    };
    # Additional package overlays
    overlays.nixpkgs.overlays = import ./lib/overlay {inherit unstable;};
    # macOS and nixOS systems
    systems = import ./lib/systems.nix {inherit modules flake-inputs;};
  in
    {
      darwinConfigurations = systems.darwinConfigurations;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;
        devShell = with pkgs;
          mkShell {
            buildInputs = [rnix-lsp];
          };
      }
    );
}

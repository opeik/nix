{
  description = "opeik's nixpkgs and macOS configuration";

  inputs = {
    # nixOS support.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs-channels/nixos-unstable";
    # macOS support.
    macos = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Manages user home directories declaratively.
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix user repository.
    nur = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix cache configurator.
    cachix.url = "github:jonascarpay/declarative-cachix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, macos, home, nur, cachix, ... }:
    let
      # Package overlays.
      unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      overlays = { nixpkgs.overlays = [ unstable nur.overlay ]; };
      # Shared modules.
      sharedModules = [ ./modules overlays cachix.nixosModules.declarative-cachix ];
      # nixOS specific modules.
      nixosModules = [
        ./modules/nixos
        home.nixosModules.home-manager
        { home-manager.sharedModules = [ ]; }
      ];
      # macOS specific modules.
      macosModules = [
        ./modules/macos
        home.darwinModules.home-manager
        { home-manager.sharedModules = [ ]; }
      ];

      # Creates a nixOS system configuration.
      nixosConfig = { system, modules }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = modules ++ nixosModules ++ sharedModules;
        };

      # Creates a macOS system configuration.
      macosConfig = { system, modules }:
        macos.lib.darwinSystem {
          inherit system;
          modules = modules ++ macosModules ++ sharedModules;
        };
    in
    {
      # nixOS hosts.
      nixosConfigurations = { };

      # macOS hosts.
      darwinConfigurations = {
        reimu = macosConfig {
          system = "aarch64-darwin";
          modules = [ ./hosts/reimu ./profiles/personal ];
        };
        reimu-ci = macosConfig {
          system = "x86_64-darwin";
          modules = [ ./hosts/reimu ./profiles/personal ];
        };
        marisa = macosConfig {
          system = "aarch64-darwin";
          modules = [ ./hosts/marisa ./profiles/work ];
        };
      };
    };
}

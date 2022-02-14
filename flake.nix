{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    cachix.url = "github:jonascarpay/declarative-cachix";
    macos = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, macos, home, cachix, ... }:
    let
      config.flake = {
        user = "opeik";
      };

      sharedModules = [ ./modules config overlays cachix.nixosModules.declarative-cachix ];
      macosModules = [ ./modules/macos.nix home.darwinModules.home-manager ];
      overlays.nixpkgs.overlays = [
        (final: prev: {
          unstable = import unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
        })
      ];

      makeMacosConfig = { host, system, modules }:
        macos.lib.darwinSystem {
          inherit system;
          modules = modules ++ macosModules ++ sharedModules ++ [ config ] ++ [{
            networking.hostName = host;
          }];
        };
    in
    {
      darwinConfigurations = {
        reimu = makeMacosConfig {
          host = "reimu";
          system = "aarch64-darwin";
          modules = [ ./profiles/personal ];
        };

        reimu-ci = makeMacosConfig {
          host = "reimu-ci";
          system = "x86_64-darwin";
          modules = [ ./profiles/personal ];
        };

        marisa = makeMacosConfig {
          host = "marisa";
          system = "aarch64-darwin";
          modules = [ ./profiles/work ];
        };
      };
    };
}

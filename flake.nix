# Nix flake, see: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    lix-module,
    nix-darwin,
    home-manager,
    ...
  }: let
    overlays.nixpkgs = import ./lib/overlay {inherit nixpkgs-unstable;};

    # macOS and nixOS modules
    modules = {
      macos = [./os/macos home-manager.darwinModules.home-manager];
      shared = [./lib/options.nix overlays lix-module.nixosModules.default];
    };

    readConfig = path: builtins.fromTOML (builtins.readFile path);

    macosSystem = {
      arch,
      config,
      osModules,
      homeModules,
    }: let
      systemConfig = config;
    in
      nix-darwin.lib.darwinSystem {
        system = arch;
        modules =
          modules.macos
          ++ modules.shared
          ++ osModules
          ++ [
            ({config, ...}: systemConfig)
            ({config, ...}: {home-manager.users.${config.username}.imports = homeModules;})
          ];

        specialArgs = {
          root = ./.;
        };
      };
  in
    {
      darwinConfigurations = {
        marisa = macosSystem {
          arch = "aarch64-darwin";
          config = readConfig ./user/opeik/config.toml;
          osModules = [./user/opeik/macos ./machine/marisa/macos.nix];
          homeModules = [./user/opeik/home-manager];
        };

        reimu = macosSystem {
          arch = "aarch64-darwin";
          config = readConfig ./user/opeik/config.toml;
          osModules = [./user/opeik/macos ./machine/reimu/macos.nix];
          homeModules = [./user/opeik/home-manager ./machine/reimu/home-manager.nix];
        };

        work = macosSystem {
          arch = "aarch64-darwin";
          config = readConfig ./user/opeik/config.toml // readConfig ./machine/work/config.toml;
          osModules = [./user/opeik/macos];
          homeModules = [./user/opeik/home-manager];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;
        devShell = with pkgs;
          mkShell {
            buildInputs = [nil self.formatter.${system}];
          };
      }
    );
}

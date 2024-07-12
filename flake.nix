# Nix flake, see: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = flake-inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    flake-utils,
    ...
  }: let
    # macOS and nixOS modules
    modules = {
      macos = [./os/macos home-manager.darwinModules.home-manager];
      shared = [./lib/options.nix];
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
          inherit flake-inputs;
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

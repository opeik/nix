{
  description = "opeik's nixpkgs and macOS configuration";

  inputs = {
    # nixOS support.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    # Fixes VSCode remote server on nixOS.
    vscode-server.url = "github:yaxitech/vscode-server-fixup";
    # Nix cache configurator.
    cachix.url = "github:jonascarpay/declarative-cachix";
  };

  outputs = { self, nixpkgs, macos, home, nur, vscode-server, cachix, ... }:
    let
      # Package overlays.
      overlays = { nixpkgs.overlays = [ nur.overlay ]; };
      # Shared modules.
      sharedModules = [ ./modules overlays cachix.nixosModules.declarative-cachix ];
      # nixOS specific modules.
      nixosModules = [
        ./modules/nixos
        home.nixosModules.home-manager
        vscode-server.nixosModules.system
        {
          home-manager.sharedModules = [ vscode-server.nixosModules.home ];
        }
      ];
      # macOS specific modules.
      macosModules = [
        ./modules/macos
        home.darwinModules.home-manager
        {
          home-manager.sharedModules = [ ./home/copy-apps.nix ];
        }
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
      nixosConfigurations = {
        # Work laptop, Dell Precision 7550 (2020).
        marisa = nixosConfig {
          system = "x86_64-linux";
          modules = [ ./hosts/marisa ./profiles/work ];
        };
      };

      # macOS hosts.
      darwinConfigurations = {
        # Personal desktop, Mac mini M1 (2020).
        reimu = macosConfig {
          system = "aarch64-darwin";
          modules = [ ./hosts/reimu ./profiles/personal ];
        };
        # Duplicate of `reimu` except x86_64 for CI use.
        reimu-ci = macosConfig {
          system = "x86_64-darwin";
          modules = [ ./hosts/reimu ./profiles/personal ];
        };
      };
    };
}

# macOS and nixOS system configurations
{ flake-inputs, modules, ... }:
let
  inherit (flake-inputs) nixpkgs nix-darwin;
  inherit (nixpkgs) lib;

  # Returns a set of all macOS and nixOS systems for all users
  systems = lib.foldl (x: y: lib.recursiveUpdate x y) { } (builtins.map userSystem users);

  # Returns a list of all users
  users = lib.mapAttrsToList (name: type: name)
    (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../user));

  # Returns the directory for the specified user
  userDir = user: ./.. + "/user/${user}";

  # Returns a list of modules for the specified user and OS
  userModules = user: os:
    let dir = userDir user; in
    [
      (builtins.fromTOML (builtins.readFile "${dir}/config.toml"))
      ({ config, ... }: {
        home-manager.users.${config.username} = { };
      })
    ] ++
    lib.optional (builtins.pathExists "${dir}/home.nix") ({ config, ... }: {
      home-manager.users.${config.username}.imports = [ "${dir}/home.nix" ];
    }) ++ lib.optional (builtins.pathExists "${dir}/home") ({ config, ... }: {
      home-manager.users.${config.username}.imports = [ "${dir}/home" ];
    }) ++ lib.optional (builtins.pathExists "${dir}/${os}.nix") ({
      imports = [ "${dir}/${os}.nix" ];
    });

  # Returns a set of all macOS and nixOS systems for the specified user
  userSystem = user: {
    darwinConfigurations = {
      "${user}-aarch64" = macosSystem { inherit user; system = "aarch64-darwin"; };
      "${user}-x86_64" = macosSystem { inherit user; system = "x86_64-darwin"; };
    };
  };

  # Returns the macOS system for the specified user
  macosSystem = { system, user }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      modules = modules.macos ++ modules.shared ++ (userModules user "macos");
      specialArgs = { root = ./..; inherit flake-inputs; };
    };
in
systems

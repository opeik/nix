# macOS and nixOS system configurations
{
  flake-inputs,
  modules,
  ...
}: let
  inherit (flake-inputs) nixpkgs nix-darwin;
  inherit (nixpkgs) lib;

  # Returns a set of all macOS and nixOS systems for all users
  systems = lib.foldl (x: y: lib.recursiveUpdate x y) {} (builtins.map userSystems users);

  # Returns a list of all directories in a path
  getDirs = path:
    lib.mapAttrsToList (name: type: name)
    (lib.filterAttrs (name: type: type == "directory") (builtins.readDir path));

  # Returns a list of all users
  users = getDirs ../system/user;
  # Returns a list of all machines
  machines = getDirs ../system/machine;

  # Returns the directory for the specified user
  userDir = user: ./.. + "/system/user/${user}";
  # Returns the directory for the specified machine
  machineDir = machine: ./.. + "/system/machine/${machine}";

  # Returns a list of modules for the specified user and OS
  getUserModules = user: os: let
    dir = userDir user;
  in
    [
      (builtins.fromTOML (builtins.readFile "${dir}/config.toml"))
      ({config, ...}: {
        home-manager.users.${config.username} = {};
      })
    ]
    ++ lib.optional (builtins.pathExists "${dir}/home-manager.nix") ({config, ...}: {
      home-manager.users.${config.username}.imports = ["${dir}/home-manager.nix"];
    })
    ++ lib.optional (builtins.pathExists "${dir}/home-manager") ({config, ...}: {
      home-manager.users.${config.username}.imports = ["${dir}/home-manager"];
    })
    ++ lib.optional (builtins.pathExists "${dir}/${os}.nix") {
      imports = ["${dir}/${os}.nix"];
    };

  # Returns a list of modules for the specified machine
  getMachineModules = machine: os: let
    dir = machineDir machine;
  in
    lib.optional (builtins.pathExists "${dir}/config.toml") ({config, ...}: (lib.mkForce (builtins.fromTOML (builtins.readFile "${dir}/config.toml"))))
    ++ lib.optional (builtins.pathExists "${dir}/home-manager.nix") ({config, ...}: {
      home-manager.users.${config.username}.imports = ["${dir}/home-manager.nix"];
    })
    ++ lib.optional (builtins.pathExists "${dir}/home-manager") ({config, ...}: {
      home-manager.users.${config.username}.imports = ["${dir}/home-manager"];
    })
    ++ lib.optional (builtins.pathExists "${dir}/${os}.nix") {
      imports = ["${dir}/${os}.nix"];
    };

  # Returns a set of all macOS and nixOS systems for the specified user
  userSystems = let
    system = "aarch64-darwin";
  in
    user:
      lib.foldl (x: y: lib.recursiveUpdate x y) {} (builtins.map
        (machine: {
          darwinConfigurations = {
            "${user}-${system}" = macosSystem {
              inherit user system;
            };
            "${user}-${machine}-${system}" = macosSystem {
              inherit user system;
              extraModules = getMachineModules machine "macos";
            };
          };
        })
        machines);

  # Returns the macOS system for the specified user
  macosSystem = {
    system,
    user,
    extraModules ? [],
  }:
    nix-darwin.lib.darwinSystem {
      inherit system;
      modules = modules.macos ++ modules.shared ++ extraModules ++ (getUserModules user "macos");
      specialArgs = {
        root = ./..;
        inherit flake-inputs;
      };
    };
in
  systems

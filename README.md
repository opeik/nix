# nix

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This repo contains the nix config which I use on my macOS machines.
The initial structure was inspired by
[davegallant/nixos-config](https://github.com/davegallant/nix-config).

## Installing

To install, run:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/opeik/nix/main/install | bash
```

## Rebuilding

To rebuild the system, run:

```sh
rebuild [config]
```

By default, your hostname will be used as the config. This script is a handy shortcut for:

```sh
nix bulid ".#darwinConfigurations.$config.config.system.build.toplevel"
./result/sw/bin/darwin-rebuild switch --flake ".#$config"
```


## Updating

To update flake inputs, including nixpkgs, run:

```sh
nix flake update
```

If there are updates they will be reflected in [`flake.lock`](./flake.lock).

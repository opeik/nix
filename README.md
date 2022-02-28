# nix

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This repo contains the nix config which I use on my macOS machines.
The initial structure was inspired by
[davegallant/nixos-config](https://github.com/davegallant/nix-config).

## Installing

To install, run:

```sh
git clone https://github.com/opeik/nix && cd nix
./install.sh --email <email>
```

## Updating

To update flake inputs, including nixpkgs, run:

```sh
nix flake update
```

If there are updates they will be reflected in [`flake.lock`](./flake.lock).

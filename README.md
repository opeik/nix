# nix

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This repo contains the nix config which I use on my macOS and nixOS machines.
The initial structure was inspired by
[davegallant/nixos-config](https://github.com/davegallant/nix-config).

## Bootstrapping

### macOS

Run:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/opeik/nix/main/install | bash
```

### nixOS

1. Enable Flakes by adding the following to `/etc/nixos/configuration.nix`

   ```nix
   {
     package = pkgs.nix_2_4;
     extraOptions = "experimental-features = nix-command flakes";
   }
   ```

2. Bootstrap

   ```sh
   nixos-rebuild switch --flake .#$host
   ```

## Switching

- Switch the current configuration

  ```sh
  nix-switch
  ```

- Switch to the configuration `foobar`

  ```sh
  nix-switch foobar
  ```

## Update nixpkgs

To update nixpkgs defined in [flake.nix](./flake.nix), run

```sh
nix flake update
```

If there are updates, they should be reflected in [flake.lock](./flake.lock).

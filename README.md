# nix

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This repo contains the nix config which I use on my macOS and nixOS machines.
The initial structure was inspired by
[davegallant/nixos-config](https://github.com/davegallant/nix-config).

## Bootstrapping

### macOS

1. Install Nix

```sh
sh <(curl -L https://nixos.org/nix/install
```

2. Install nix-darwin

```sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

3. Enable flakes

```sh
nix-env -iA nixpkgs.nix_2_4
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

4. Build

```sh
nix build ".#darwinConfigurations.$host.system"
./result/sw/bin/darwin-rebuild switch --flake .#$host
```

5. Update default shell

```sh
chsh -s /run/current-system/sw/bin/fish
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
  ./switch.sh
  ```

- Switch to the configuration `foobar`

  ```sh
  ./switch.sh foobar
  ```

## Update nixpkgs

To update nixpkgs defined in [flake.nix](./flake.nix), run

```sh
nix flake update
```

If there are updates, they should be reflected in [flake.lock](./flake.lock).

## Switching

To quickly switch Nix generations, run:

```sh
nix-switch
```

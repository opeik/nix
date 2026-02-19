# nix

My nixOS and macOS configurations.

> [!NOTE]
> The term "macOS" in this repo usually refers to [`nix-darwin`](https://github.com/LnL7/nix-darwin/tree/master).

## Installation

See [`./flake.nix`](./flake.nix) for valid systems, run:
```sh
export SYSTEM=reimu
# Install Nix.
curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh -s -- install
# Fetch Nix configs.
git clone https://github.com/opeik/nix && cd nix
# Apply the system config.
nix build ".#darwinConfigurations.$SYSTEM.system" && ./result/sw/bin/darwin-rebuild switch --flake ".#$SYSTEM"
```

## Usage

Once installed, simply run `nixy` to update the Nix config.

## Structure

- `lib`: shared scaffolding
  - `home-manager`: custom home-manager modules
    - `macos`: macOS-specific custom home-manager modules
  - `macos`: custom macOS modules
  - `overlay`: Nix package overlays
  - `options.nix`: system option definitions
- `machine`: machine-specific config, each machine is a physical computer
  - `{machine_name}`
    - `home-manager`: extra home-manager config for `{machine_name}`
    - `macos`: extra macOS config for `{machine_name}`
    - `config.toml`: extra system options for `{machine_name}`
- `os`: os-specific base config
  - `macos`: base macOS config
- `user`: user-specific config
  - `{user_name}`
    - `home-manager`: extra user-specific home-manager config
    - `macos`: extra user-specific macOS config
    - `config.toml`: extra user-specific system options

### Notes
- Don't add extra config to `os`, it's only supposed to initialize the environment
- Scope extra config to either:
  - a user: `user/{user_name}/macos`, or
  - a machine: `machine/{machine_name}/macos`

# Nix flake, see: <https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake>
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
        with pkgs; {
          # `nix develop`
          devShells.default = mkShell {
            buildInputs = [
              (rust-bin.stable.latest.default.override {
                extensions = ["rust-src"];
              })
            ];
          };
        }
    );
}

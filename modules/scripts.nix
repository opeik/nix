{ pkgs, ... }:
let
  # Script to quickly update the system configuration.
  flakePath = if pkgs.stdenv.isDarwin then "/Users/opeik/Development/nix" else "/home/opeik/Development/nix";
  nix-switch = with pkgs; pkgs.writeShellScriptBin "nix-switch" ./scripts/nix-switch.sh;
  code-update = with pkgs; writeShellScriptBin "code-update" ./scripts/code-update.sh;
in
{
  environment.systemPackages = [ nix-switch code-update ];
}

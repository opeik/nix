{ pkgs, ... }:
let
  # Script to quickly update the system configuration.
  flakePath = if pkgs.stdenv.isDarwin then "/Users/opeik/Development/nix" else "/home/opeik/Development/nix";
  dot = with pkgs; pkgs.writeShellScriptBin "dot" ./scripts/dot.sh;
  code-update = with pkgs; writeShellScriptBin "code-update" ./scripts/code-update.sh;
in
{
  environment.systemPackages = [ dot code-update ];
}

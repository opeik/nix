# Makes a Nix package from a macOS .app bundle
{ pkgs, ... }:
let
  lib = pkgs.lib;
in
{
  pkgFromApp =
    { name
    , appName ? name
    , version
    , src
    , description
    , homepage
    , buildInputs ? [ ]
    , unpackPhase ? ""
    , postInstall ? ""
    , sourceRoot ? "${appName}.app"
    , ...
    }:
    pkgs.stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      inherit src;
      inherit sourceRoot;
      buildInputs = with pkgs; [ undmg unzip ] ++ buildInputs;
      phases = [ "unpackPhase" "installPhase" ];
      inherit unpackPhase;
      installPhase = ''
        mkdir -p "$out/Applications/${appName}.app"
        cp -pR * "$out/Applications/${appName}.app"
      '' + postInstall;
      meta = with lib; {
        inherit description;
        inherit homepage;
        maintainers = with maintainers; [ ];
        platforms = platforms.darwin;
      };
    };
}

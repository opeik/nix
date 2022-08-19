# macOS apps overlay
final: prev:
let
  inherit (prev) pkgs lib stdenv;

  # Makes a Nix package from a macOS .app bundle
  pkgFromApp =
    { pname
    , appname ? pname
    , binname ? pname
    , version
    , src
    , description
    , homepage
    , unpackPhase ? ""
    , sourceRoot ? "${appname}.app"
    , ...
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname src sourceRoot unpackPhase;
      version = "${version}";
      buildInputs = with pkgs; [ makeWrapper undmg unzip ];
      installPhase = ''
        runHook preInstall
        mkdir -p $out/{bin,Applications/"${appname}.app"}
        cp -R . "$out/Applications/${appname}.app"
        makeWrapper "$out/Applications/${appname}.app/Contents/MacOS/${binname}" "$out/bin/${pname}"
        runHook postInstall
      '';
      meta = {
        inherit description homepage;
        platforms = lib.platforms.darwin;
      };
    };
in
{
  macos-apps = {
    docker-desktop = pkgFromApp rec {
      pname = "docker-desktop";
      appname = "Docker";
      binname = appname;
      version = "4.5.0";
      revision = "74594";
      src = builtins.fetchurl {
        url = "https://desktop.docker.com/mac/main/arm64/${revision}/Docker.dmg";
        sha256 = "0161vncg3aq1xlakr0wxsw3lnbxjxc8frqrv6lx9h9cr8rwz7sr4";
      };
      description = "Docker desktop client";
      homepage = "https://docker.com";
    };

    mos = pkgFromApp rec {
      pname = "mos";
      appname = "Mos";
      version = "3.3.2";
      src = builtins.fetchurl {
        url = "https://github.com/Caldis/Mos/releases/download/${version}/Mos.Versions.${version}.dmg";
        sha256 = "1n6bfwp3jg0izr5ay8li7mp23j9win775a4539z4b4604a8bpy2z";
      };
      description = "Mouse improvements";
      homepage = "https://mos.caldis.me";
    };

    rectangle = pkgFromApp rec {
      pname = "rectangle";
      appname = "Rectangle";
      version = "0.53";
      src = builtins.fetchurl {
        url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
        sha256 = "0ws2p8vwa825qwi5gv4ppn8l4j77vg8wpk0aw05dp336016637km";
      };
      description = "Window snapping and management";
      homepage = "https://rectangleapp.com";
    };

    yubico-authenticator = pkgFromApp rec {
      pname = "yubico-auth";
      appname = "Yubico Authenticator";
      binname = "yubioath-desktop";
      version = "5.1.0";
      src = builtins.fetchurl {
        url = "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-${version}-mac.pkg";
        sha256 = "1iaq6z4fy0icrzmm41bici9jpyp8dlm0hj3sc0jbdk9b3rw6b3zp";
      };
      description = "Yubico TOTP generator";
      homepage = "https://www.yubico.com/products/yubico-authenticator";
      unpackPhase = ''
        ${pkgs.p7zip}/bin/7z x $src
        ${pkgs.libarchive}/bin/bsdtar -xf Payload~
      '';
    };
  };
}

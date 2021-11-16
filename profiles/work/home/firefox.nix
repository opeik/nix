# Hack, the existing `firefox-wayland` package is subtly broken.
# See: `https://github.com/NixOS/nixpkgs/issues/87895#issuecomment-898191204`.
{ pkgs, lib, ... }:
let
  myFirefox = (pkgs.firefox.overrideAttrs (_: {
    desktopItem =
      pkgs.makeDesktopItem {
        name = "firefox";
        exec = "env MOZ_ENABLE_WAYLAND=1 MOZ_DBUS_REMOTE=1 firefox %u";
        icon = "firefox";
        comment = "";
        desktopName = "Firefox";
        genericName = "Web Browser";
        categories = "Network;WebBrowser;";
        mimeType = lib.concatStringsSep ";" [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
      };
  }));
in
{
  programs.firefox = {
    enable = true;
    package = myFirefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      onepassword-password-manager
      multi-account-containers
    ];
    profiles.opeik.settings = {
      "browser.startup.page" = 3; # Restore last session on startup.
    };
  };
}

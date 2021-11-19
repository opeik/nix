{ pkgs, lib, ... }:
{
  programs.chromium = {
    enable = true;
    package =
      (pkgs.chromium.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
        ];
      });
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "khgocmkkpikpnmmkgmdnfckapcdkgfaf"; } # 1Password
    ];
  };

  # Use `chromium` as the default browser.
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "chromium" ];
    "text/xml" = [ "chromium" ];
    "application/xhtml+xml" = [ "chromium" ];
    "application/vnd.mozilla.xul+xml" = [ "chromium" ];
    "x-scheme-handler/http" = [ "chromium" ];
    "x-scheme-handler/https" = [ "chromium" ];
    "x-scheme-handler/ftp" = [ "chromium" ];
  };
}

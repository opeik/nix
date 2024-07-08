{
  lib,
  osConfig,
  ...
}: let
  css = {
    window-control-placeholder-support = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/MrOtherGuy/firefox-csshacks/master/chrome/window_control_placeholder_support.css";
      sha256 = "1wf1wicj1x4c4r81g48djfwyqxszk4d22xhr0pgzsbk3vy9ryi9m";
    };
    hide-tabs-toolbar = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/MrOtherGuy/firefox-csshacks/master/chrome/hide_tabs_toolbar_osx.css";
      sha256 = "0kkjla3dy2rxna1yay3wjwj4sxcviskisxq2zzl08nymvm2j9myq";
    };
  };
  userchrome = builtins.toFile "userChrome.css" (builtins.concatStringsSep "\n" [
    (builtins.readFile css.window-control-placeholder-support)
    (builtins.readFile css.hide-tabs-toolbar)
  ]);
in {
  home.activation.firefox-chrome = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -x
    run find '/Users/${osConfig.username}/Library/Application Support/Firefox/Profiles' -name '*.default-release' \
      -exec mkdir -p '{}/chrome' \; \
      -exec ln -sf ${userchrome} '{}/chrome/userChrome.css'  \;
    set +x
  '';
}

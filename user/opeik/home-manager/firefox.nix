{
  lib,
  osConfig,
  ...
}: {
  home.activation.firefox-chrome = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -x
    run find '/Users/${osConfig.username}/Library/Application Support/Firefox/Profiles' -name '*.default-release' \
      -exec mkdir -p '{}/chrome' \; \
      -exec ln -sf ${./userChrome.css} '{}/chrome/userChrome.css'  \;
    set +x
  '';
}

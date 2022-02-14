{ lib, ... }: {
  # Alias apps to `~/Applcations` for SpotLight indexing.
  home.activation = {
    aliasApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      apps_path="$HOME/Applications";
      for app in $genProfilePath/home-path/Applications/*.app; do
        app_alias="$(basename "$app")"
        $DRY_RUN_CMD rm -f "$apps_path/$app_alias"
        $DRY_RUN_CMD osascript \
          -e "tell app \"Finder\"" \
          -e "make new alias file at POSIX file \"$apps_path\" to POSIX file \"$app\"" \
          -e "set name of result to \"$app_alias\"" -e "end tell" >/dev/null
      done
    '';
  };
}

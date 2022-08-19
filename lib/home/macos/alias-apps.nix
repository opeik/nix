# Implements ~/Applications management
{ config, lib, pkgs, ... }: {
  options.macos.aliasApps.enabled = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Aliases macOS .app bundles to ~/Applications.
    '';
  };

  config.home.activation =
    let
      isEnabled = config.macos.aliasApps.enabled;
    in
    {
      aliasApps = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
        app_dir="$HOME/Applications";
        $DRY_RUN_CMD mkdir -p "$app_dir"

        # Delete existing aliases
        for app in "$app_dir"/*.app; do
          if [ "$(mdls -raw -name kMDItemKind "$app")" = "Alias" ]; then
            $DRY_RUN_CMD rm -f "$app"
          fi
        done

        # Alias all user apps
        for app in "$newGenPath"/home-path/Applications/*.app; do
          app_name=$(basename "$app"); app_path=$(realpath "$app")

          $DRY_RUN_CMD rm -f "$app_dir/$app_name" && $DRY_RUN_CMD osascript \
            -e "tell app \"Finder\"" \
              -e "make new alias file at POSIX file \"$app_dir\" to POSIX file \"$app_path\"" \
              -e "set name of result to \"$app_name\"" \
            -e "end tell" >/dev/null
        done
      '';
    };
}

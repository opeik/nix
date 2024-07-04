# fish configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.fish.enable>
{osConfig, ...}: {
  config.programs.direnv.enableNushellIntegration = false;
  config.programs.starship.enableNushellIntegration = false;
  config.programs.atuin.enableNushellIntegration = false;

  config.programs.nushell = {
    enable = true;
    configFile.text = (
      builtins.concatStringsSep "\n" [
        (builtins.readFile ./generated/config.nu)
        (builtins.readFile ./config.nu)
      ]
    );

    envFile.text = (
      builtins.concatStringsSep "\n" [
        (builtins.readFile ./generated/env.nu)
        (builtins.readFile ./env.nu)
      ]
    );

    extraEnv = ''
      $env.PATH = /usr/local/bin:
      $env.PATH = $env.PATH | split row (char esep)
        | append ($env.HOME | path join '.nix-profile/bin')
        | append '/etc/profiles/per-user/${osConfig.username}/bin'
        | append '/nix/var/nix/profiles/default/bin'
        | append '/run/current-system/sw/bin'
        | append '/opt/homebrew/bin'
        | uniq # filter so the paths are unique
    '';
  };
}
#/etc/profiles/per-user/opeik/bin
# /nix/var/nix/profiles/default/bin
# /run/current-system/sw/bin
# /usr/local/bin
# /System/Cryptexes/App/usr/bin
# /usr/bin
# /bin
# /usr/sbin
# /sbin
# /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
# /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
# /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
# /Applications/Wireshark.app/Contents/MacOS
# /nix/store/2qwiw8qcim6sc4ln7ylby4h91wn3wx57-rust-default-1.79.0/bin
# /Users/opeik/.nix-profile/bin
# /opt/homebrew/bin


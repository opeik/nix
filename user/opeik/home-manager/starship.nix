# starship config, see: https://nix-community.github.io/home-manager/options#opt-programs.starship.enable
{pkgs, ...}: {
  programs.starship = {
    enable = true;
    # starship settings, see: https://starship.rs/config
    settings = {
      username.show_always = true; # Always show username in prompt
      username.style_user = "bold bright-yellow"; # Improve contrast of username
      nix_shell.disabled = true;
      command_timeout = 100;

      format = builtins.concatStringsSep "" [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$pijul_channel"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$\{custom.nix}"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$os"
        "$container"
        "$shell"
        "$character"
      ];

      battery.disabled = true;

      custom.nix = {
        symbol = "❄️️️ ";
        style = "bold cyan";
        format = "via [$symbol nix( $output)]($style) ";
        command = ''
          if [ -n "$IN_NIX_SHELL" ]; then
            printf 'develop\n'
          fi
        '';
        when = ''[ -n "$IN_NIX_SHELL" ]'';
        shell = ["sh" "--norc"];
      };
    };
  };

  # Install powerline fonts for starship
  home.packages = with pkgs; [nerd-fonts.fira-code];
  # Show helpful command-not-found messages.
  programs.nix-index.enable = true;
}

{ pkgs, ... }:
let
  # Script to quickly update the system configuration.
  flakePath = if pkgs.stdenv.isDarwin then "/Users/opeik/dev/nix" else "/home/opeik/dev/nix";
  nix-switch = pkgs.writeShellScriptBin "nix-switch" ''
    #!/bin/sh
    set -euo pipefail

    host="''${1-$(hostname)}"

    # Prints a command prior to execution.
    run() {
        CMD="''${@}"
        printf "$(green info:) running: \`''${CMD}\`\n"
        ''${@}
    }

    # Prints the specified string in green.
    green() {
        GREEN='\033[1;32m'
        CLEAR='\033[0m'
        printf "''${GREEN}''${1}''${CLEAR}"
    }

    main() {
        printf "$(green info:) switching host \`''${host}\`...\n"
        run cd '${flakePath}'
        run git pull --quiet
        printf "$(green info:) updating vscode extensions...\n"
        ./get-vscode-extensions.sh vadimcn.vscode-lldb matklad.rust-analyzer > home/vscode/extensions.nix

        case "$OSTYPE" in
        "darwin"*)
            run sudo darwin-rebuild switch --flake ".#''${host}"
            ;;
        "linux-gnu"*)
            run sudo nixos-rebuild switch --flake ".#''${host}"
            ;;
        *)
            printf "unsupported os"
            exit 1
            ;;
        esac

        printf "$(green info:) switch ok!\n"
    }

    main
  '';
in
{
  environment.systemPackages = [ nix-switch ];
}

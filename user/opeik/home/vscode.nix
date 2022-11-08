# VSCode configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.vscode.enable>
{ pkgs, ... }: {
  programs.vscode = {
    enable = true; # Install VSCode, a cross platform text editor
    package = pkgs.unstable.vscode; # Use the latest version of VSCode
  };
}

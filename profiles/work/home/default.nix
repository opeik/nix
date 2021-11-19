{ ... }: {
  imports = [
    ./chromium.nix
    ./git.nix
    ./mime.nix
    ./ssh.nix
    ./vscode-server.nix
  ];
}

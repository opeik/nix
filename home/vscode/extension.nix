{ pkgs, ... }: {
  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      # Prefer the packaged version for extensions which require binaries,
      # such as language servers.
      vadimcn.vscode-lldb
      matklad.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix).extensions;
  };
}

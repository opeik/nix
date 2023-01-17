# git configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.git.enable>
{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  programs.git = {
    enable = true; # Enable git, the stupid content tracker
    package = pkgs.unstable.git; # Use the latest git version.
    userName = osConfig.name; # Set the git user name
    userEmail = osConfig.email; # Set the git user email
    ignores = [".DS_Store"]; # Global file ignore list

    # git settings, see: <https://git-scm.com/docs/git-config#_variables>
    extraConfig = {
      core = {
        eol = "lf"; # Always use Unix line endings
        autocrlf = false; # Don't automatically convert line endings
        editor = "code --wait"; # Use VSCode as the commit message editor
      };

      # Use the same branch names locally and remotely
      push = {
        default = "current";
        autoSetupRemote = true;
      };

      merge.tool = "vscode"; # Use VSCode as the merge tool
      diff.tool = "vscode"; # Use VSCode as the diff tool
      difftool.vscode.cmd = "code --wait --diff $LOCAL $REMOTE"; # Setup VSCode diffing
      init.defaultBranch = "main"; # Use `main` as the default branch name
      pull.rebase = true; # Always rebase instead of merge
      rebase.autoStash = true; # Automatically stash unstaged changes then reapply after an action

      # If signing code, use 1Password.
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    # Setup git-town aliases.
    aliases =
      lib.genAttrs [
        "append"
        "hack"
        "kill"
        "new-pull-request"
        "prepend"
        "append"
        "prune-branch"
        "repo"
        "ship"
        "sync"
      ]
      (name: "town ${name}");
  };
}

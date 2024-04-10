# git configuration, see: <https://nix-community.github.io/home-manager/options#opt-programs.git.enable>
{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  programs.git = {
    enable = true; # Enable git, the stupid content tracker
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

      diff.external = "${pkgs.difftastic}/bin/difft";
      diff.tool = "difftastic";
      difftool.difftastic.cmd = ''${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"''; # Setup VSCode diffing
      difftool.prompt = false;
      merge.tool = "vscode"; # Use VSCode as the merge tool
      pager.difftastic = true;
      init.defaultBranch = "main"; # Use `main` as the default branch name
      pull.rebase = true; # Always rebase instead of merge
      rebase.autoStash = true; # Automatically stash unstaged changes then reapply after an action

      # If signing code, use 1Password.
      gpg.format = "ssh";
      # Set the signing key.
      commit.gpgsign = true;
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIecOpIZJm2t6IPK/FBsNN26eoIAKVHt/IP+8irtjXs4";
    };

    # Setup git-town aliases.
    aliases =
      lib.genAttrs [
        # Basic workflow
        "hack"
        "sync"
        "switch"
        "propose"
        "ship"
        # Additional commands
        "kill"
        "rename-branch"
        "repo"
        # Nested feature branches
        "append"
        "prepend"
        "set-parent"
        "diff-parent"
        # Dealing with errors
        "continue"
        "skip"
        "status"
        "undo"
      ]
      (name: "town ${name}");
  };
}

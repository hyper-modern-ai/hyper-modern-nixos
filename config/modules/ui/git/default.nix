{ ... }: {
  primary-user.home-manager.programs.git = {

    enable = true;
    userName = "__reinit_ctx_offset";
    userEmail = "reinit-ctx-offset@xz.team";

    extraConfig = {
      branch = { sort = "-committerdate"; };

      column = { ui = "auto"; };

      gpg = { format = "ssh"; };

      init = { defaultBranch = "main"; };

      merge = {
        # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#merge-conflictstyle-zdiff3
        conflictstyle = "zdiff3";
      };

      pull = {
        # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#pull-ff-only-or-pull-rebase-true
        rebase = true;
      };

      push = {
        # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#push-default-simple-push-default-current
        autoSetupRemote = true;
      };

      # https://jvns.ca/blog/2024/02/16/popular-git-config-options/#rerere-enabled-true
      rerere = { enabled = true; };
      safe = { directory = "/etc/nixos/flake"; };
      user = { signingKey = "~/.ssh/id_ed25519.pub"; };
    };

    includes = [{
      path = ./work-profile;
      condition = "gitdir:~/Development/Co-Star/";
    }];
  };
}

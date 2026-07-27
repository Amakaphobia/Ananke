{ config, lib, ... }:
let
  cfg = config.ananke.cli.git;
in
{
  options.ananke.cli.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        # TODO: Extract this option + sane defaults
        enable = true;
        settings = {

          user.Name = "amakaphobia";
          user.Email = "29711914+Amakaphobia@users.noreply.github.com";

          alias = {
            s = "status --short --branch";
            st = "status";
            a = "add --all";
            c = "commit";
            cm = "commit -m";
            ca = "commit --amend";
            p = "push";
          };

          init.defaultBranch = "main";

          core = {
            editor = "nvim";
            autocrlf = "input";
          };

          pull = {
            rebase = true;
          };

          rebase = {
            autoStash = true;
            autoSquash = true;
          };

          push = {
            default = "simple";
            autoSetupRemote = true;
          };

          fetch = {
            prune = true;
            pruneTags = true;
          };

          merge = {
            conflictStyle = "zdiff3";
          };

          branch = {
            sort = "-committerdate";
          };

          tag = {
            sort = "version:refname";
          };

          color = {
            ui = "auto";
          };
        };

        ignores = [
          ".direnv/"
          ".env"
          ".env.*"
          "result"
          "result-*"
          ".DS_Store"
          "*.swp"
          "*.swo"
        ];

      };
      # also git
      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
        };
      };

      gh = {
        enable = true;

        settings = {
          git_protocol = "ssh";
        };

      };
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.system.git;
in
{
  options.ananke.system.git = {
    enable = lib.mkEnableOption "git";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;

        settings = {
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

{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.ananke.home.cli.git;
in
{
  options.ananke.home.cli.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.system.programs.git.enable;
        message = "Git is not installed at system level. Use config.ananke.system.programs.git.enable = true";
      }
    ];

    programs = {
      git = {
        enable = true;
        # git is a system install
        package = null;

        settings = {
          user.Name = "amakaphobia";
          user.Email = "29711914+Amakaphobia@users.noreply.github.com";

          alias = {
            st = "status";
            a = "add --all";
            cam = "commit --all --message";
            cm = "commit -m";
            ca = "commit --amend";
            pfwl = "push --force-with-lease";
            l = "log --oneline --decorate --graph --max-count 10";
            mffo = "merge --ff-only";
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

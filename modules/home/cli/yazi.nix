{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.cli.yazi;
in
{
  options.ananke.home.cli.yazi = {
    enable = lib.mkEnableOption "Yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {

      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      extraPackages = with pkgs; [
        # markdown preview
        glow
        # archive utility ( creating, compression, previewing )
        ouch
      ];

      plugins = {
        # enter directories, open files
        "smart-enter" = pkgs.yaziPlugins.smart-enter;

        # allow any commandline tool to act as a yazi preview
        piper = pkgs.yaziPlugins.piper;

        ouch = pkgs.yaziPlugins.ouch;

        git = {
          package = pkgs.yaziPlugins.git;
          setup = true;

          settings = {
            order = 1500;
          };
        };
      };

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
        };

        plugin = {
          prepend_fetchers = [
            {
              url = "*";
              run = "git";
              group = "git";
            }
            {
              url = "*/";
              run = "git";
              group = "git";
            }
          ];
          prepend_previewers = [
            {
              url = "*.md";
              run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch";
            }
          ];
        };
      };

      keymap.mgr.prepend_keymap = [
        {
          on = [ "!" ];
          run = ''shell "$SHELL" --block'';
          desc = "Open shell here";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
          desc = "Go to Git repository root";
        }
        {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter directory or open file";
        }
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress selected files";
        }
      ];
    };
  };
}

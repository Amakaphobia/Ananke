{ config, lib, ... }:
let
  cfg = config.ananke.modules.cli.yazi;
in
{
  options.ananke.modules.cli.yazi = {
    enable = lib.mkEnableOption "Yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
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
      ];
    };
  };
}

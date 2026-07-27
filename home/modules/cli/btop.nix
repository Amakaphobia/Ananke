{ config, lib, ... }:
let
  cfg = config.ananke.cli.btop;
in
{
  options.ananke.cli.btop = {
    enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;

      settings = {
        theme_background = false;
        update_ms = 1000;
        vim_keys = true;
      };
    };
  };
}

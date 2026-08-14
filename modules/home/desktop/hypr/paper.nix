{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.desktop.hypr;
  path = toString config.ananke.profiles.home.theme.images.wallpaper;
in
{
  options.ananke.profiles.home.desktop.hypr = {
    monitor = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Monitor used by the machine. An empty string targets all monitors. Default \"\".";
    };
    paper = {
      enable = lib.mkEnableOption "Wether to install hyprpaper";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.paper.enable) {
    services.hyprpaper = {
      enable = true;

      settings = {

        splash = false;

        wallpaper = [
          {
            fit_mode = "cover";
            inherit (cfg) monitor;
            inherit path;
          }
        ];
      };
    };
  };
}

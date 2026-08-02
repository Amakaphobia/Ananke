{ config, lib, ... }:
let
  cfg = config.ananke.home.desktop.hypr;
in
{
  options.ananke.home.desktop.hypr.sunset = {
    enable = lib.mkEnableOption "Hypr Sunset";
  };
  config = lib.mkIf (cfg.enable && cfg.sunset.enable) {
    services.hyprsunset = {
      enable = true;

      settings = {
        profile = [
          {
            time = "07:00";
            identity = true;
          }
          {
            time = "18:00";
            temperature = 6000;
          }
          {
            time = "19:00";
            temperature = 5500;
          }
          {
            time = "20:00";
            temperature = 5000;
          }
          {
            time = "21:00";
            temperature = 4500;
          }
          {
            time = "22:00";
            temperature = 4000;
          }
        ];
      };
    };
  };
}

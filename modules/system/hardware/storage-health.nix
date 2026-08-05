{ config, lib, ... }:

let
  cfg = config.ananke.hardware.storage-health;
in
{
  options.ananke.hardware.storage-health = {
    enable = lib.mkEnableOption "storage health monitoring with smartd";
  };

  config = lib.mkIf cfg.enable {
    services.smartd = {
      enable = true;
      autodetect = true;

      notifications = {
        mail.enable = false;
        wall.enable = false;
        x11.enable = false;
        # sends a test notif on startup if true
        test = false;

        systembus-notify.enable = true;
      };
    };
  };
}

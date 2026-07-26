{ config, lib, ... }:
let
  cfg = config.ananka.desktop.hypr;
in
{
  options.ananka.desktop.hypr.idle = {
    enable = lib.mkEnableOption "Wether to install hypridle";

    lock_timeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 300;
      description = "Time in seconds until lock command gets send. Default: 300";
    };

    display_timeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 600;
      description = "Time in seconds until display turns off. Default: 600";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.idle.enable) {
    assertions = [
      {
        assertion = cfg.idle.display_timeout > cfg.idle.lock_timeout;
        message = ''
          ananka.desktop.hypr.idle.display_timeout must be
          greater than ananka.desktop.hypr.idle.lock_timeout.
        '';
      }
    ];
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock > /dev/null|| hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            #make loginctl request a lock executing lock_cmd in the process
            on-timeout = "loginctl lock-session";
            timeout = cfg.idle.lock_timeout;
          }
          {
            # monitor toggle
            timeout = cfg.idle.display_timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}

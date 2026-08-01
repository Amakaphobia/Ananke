{ config, lib, ... }:
let
  cfg = config.ananke.hardware.laptop.power-profiles-daemon;
in
{
  options.ananke.hardware.laptop.power-profiles-daemon = {
    enable = lib.mkEnableOption "power-profiles-daemon";
  };

  config = lib.mkIf (config.ananke.profiles.hardware.laptop.enable && cfg.enable) {
    # power-profiles-daemon
    services.power-profiles-daemon.enable = true;
  };
}

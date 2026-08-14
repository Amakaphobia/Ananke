{ config, lib, ... }:
let
  cfg = config.ananke.profiles.hardware.laptop.power-profiles-daemon;
in
{
  options.ananke.profiles.hardware.laptop.power-profiles-daemon = {
    enable = lib.mkEnableOption "power-profiles-daemon";
  };

  config = lib.mkIf cfg.enable {
    # power-profiles-daemon
    services.power-profiles-daemon.enable = true;
  };
}

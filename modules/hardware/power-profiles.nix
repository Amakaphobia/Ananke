{ config, lib, ... }:
let
  cfg = config.ananke.machine.laptop.power-profiles-daemon;
in
{
  options.ananke.machine.laptop.power-profiles-daemon = {
    enable = lib.mkEnableOption "power-profiles-daemon";
  };

  config = lib.mkIf (config.machine.laptop.enable && cfg.enable) {
    # power-profiles-daemon
    services.power-profiles-daemon.enable = true;
  };
}

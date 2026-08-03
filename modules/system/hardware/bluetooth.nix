{ config, lib, ... }:
let
  cfg = config.ananke.hardware.bluetooth;
in
{
  options.ananke.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}

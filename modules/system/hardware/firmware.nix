{ config, lib, ... }:

let
  cfg = config.ananke.profiles.hardware.firmware;
in
{
  options.ananke.profiles.hardware.firmware = {
    enable = lib.mkEnableOption "firmware management through fwupd";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}

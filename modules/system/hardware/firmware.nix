{ config, lib, ... }:

let
  cfg = config.ananke.hardware.firmware;
in
{
  options.ananke.hardware.firmware = {
    enable = lib.mkEnableOption "firmware management through fwupd";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.system.core.systemd;
in
{
  options.ananke.system.core.systemd = {
    enable = lib.mkEnableOption "systemd";
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}

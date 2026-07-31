{ config, lib, ... }:
let
  cfg = config.ananke.modules.system.core.systemdBoot;
in
{
  options.ananke.modules.system.core.systemdBoot = {
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

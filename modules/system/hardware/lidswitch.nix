{ config, lib, ... }:
let
  cfg = config.ananke.hardware.laptop.lidswitch;
in
{
  options.ananke.hardware.laptop.lidswitch = {
    enable = lib.mkEnableOption "lidswitch";
  };

  config = lib.mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
    };
  };
}

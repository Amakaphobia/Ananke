{ config, lib, ... }:
let
  cfg = config.ananke.machine.laptop.lidswitch;
in
{
  options.ananke.machine.laptop.lidswitch = {
    enable = lib.mkEnableOption "lidswitch";
  };

  config = lib.mkIf (config.ananke.machine.laptop.enable && cfg.enable) {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
    };
  };
}

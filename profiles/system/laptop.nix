{ config, lib, ... }:
let
  cfg = config.ananke.machine.laptop;
in
{
  imports = [
    ../../modules/system/hardware/hibernation.nix
    ../../modules/system/hardware/power-profiles.nix
    ../../modules/system/hardware/touchpad.nix
    ../../modules/system/hardware/lidswitch.nix
  ];

  options.ananke.machine.laptop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "true when machine is a laptop";
    };
  };

  config = lib.mkIf cfg.enable {
    ananke.machine.laptop = {
      hibernation.enable = lib.mkDefault true;
      lidswitch.enable = lib.mkDefault true;
      power-profiles-daemon.enable = lib.mkDefault true;
      touchpad.enable = lib.mkDefault true;
    };
  };
}

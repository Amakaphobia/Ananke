{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.hardware.laptop;
in
{
  imports = [
    (paths.modules + "/system/hardware/bluetooth.nix")
    (paths.modules + "/system/hardware/hibernation.nix")
    (paths.modules + "/system/hardware/power-profiles.nix")
    (paths.modules + "/system/hardware/touchpad.nix")
    (paths.modules + "/system/hardware/lidswitch.nix")
  ];

  options.ananke.profiles.hardware.laptop = {
    enable = lib.mkEnableOption "Laptop Profile";
    bluetooth.enable = lib.mkEnableOption "Bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    ananke.hardware = {
      bluetooth.enable = cfg.bluetooth.enable;
      laptop = {
        hibernation.enable = lib.mkDefault true;
        lidswitch.enable = lib.mkDefault true;
        power-profiles-daemon.enable = lib.mkDefault true;
        touchpad.enable = lib.mkDefault true;
      };
    };
  };
}

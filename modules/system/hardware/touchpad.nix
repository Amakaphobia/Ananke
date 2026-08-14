{ config, lib, ... }:
let
  cfg = config.ananke.profiles.hardware.laptop.touchpad;
in
{
  options.ananke.profiles.hardware.laptop.touchpad = {
    enable = lib.mkEnableOption "touchpad";
  };
  config = lib.mkIf cfg.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
  };
}

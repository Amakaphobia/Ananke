{ config, lib, ... }:
let
  cfg = config.ananke.hardware.laptop.touchpad;
in
{
  options.ananke.hardware.laptop.touchpad = {
    enable = lib.mkEnableOption "touchpad";
  };
  config = lib.mkIf cfg.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
  };
}

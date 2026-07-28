{ config, lib, ... }:
let
  cfg = config.ananke.machine.laptop.touchpad;
in
{
  options.ananke.machine.laptop.touchpad = {
    enable = lib.mkEnableOption "touchpad";
  };
  config = lib.mkIf (config.ananke.machine.laptop && cfg.enable) {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
  };
}

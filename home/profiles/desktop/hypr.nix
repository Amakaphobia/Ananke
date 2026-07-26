{ config, lib, ... }:
let
  dsk = config.ananke.desktop;
  cfg = dsk.profiles;
in
{
  imports = [
    ../../modules/hypr
    ../../modules/screenshot.nix
  ];

  options.ananke.desktop.profiles.hypr = {
    enable = lib.mkEnableOption "Enable this hyprland powered desktop profile";
    screenshot.enable = lib.mkEnableOption "Enable screenshot tools";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop.hypr.enable = true;

    ananke.desktop.screenshot.enable = cfg.hypr.screenshot.enable;

    # other desktop programs here
  };
}

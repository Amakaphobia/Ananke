{ config, lib, ... }:
let
  cfg = config.ananke.desktop.profiles;
in
{
  imports = [ ../modules/hypr ];

  options.ananke.desktop.profiles.hypr = {
    enable = lib.mkEnableOption "Enable this hyprland powered desktop profile";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop.hypr.enable = true;
    # other desktop programs here
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.profiles.desktop;
in
{
  imports = [ ../../../home/modules/desktop ];

  options.ananke.profiles.desktop.hypr = {
    enable = lib.mkEnableOption "hyprland powered desktop profile";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop = {
      hypr.enable = lib.mkDefault true;
      screenshot.enable = lib.mkDefault true;
      firefox = {
        enable = lib.mkDefault true;
        webapps.enable = lib.mkDefault true;
      };
      fuzzel.enable = lib.mkDefault true;
      kitty.enable = lib.mkDefault true;
      swaync.enable = lib.mkDefault true;
      thunar.enable = lib.mkDefault true;
      utilities.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      xdgMimeApps.enable = lib.mkDefault true;
    };

    # other desktop programs here
  };
}

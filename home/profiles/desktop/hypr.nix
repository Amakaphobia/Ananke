{ config, lib, ... }:
let
  cfg = config.ananke.desktop.profiles;
in
{
  imports = [ ../../modules/desktop ];

  options.ananke.desktop.profiles.hypr = {
    enable = lib.mkEnableOption "Enable this hyprland powered desktop profile";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop = {
      hypr.enable = lib.mkDefault true;
      screenshot.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
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

{ config, lib, ... }:
let
  cfg = config.ananke.desktop.profiles;
in
{
  imports = [
    ../../modules/hypr
    ../../modules/screenshot.nix
  ];

  options.ananke.desktop.profiles.hypr = {
    enable = lib.mkEnableOption "Enable this hyprland powered desktop profile";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop.hypr.enable = true;

    ananke.desktop.screenshot.enable = lib.mkDefault true;

    # other desktop programs here
  };
}

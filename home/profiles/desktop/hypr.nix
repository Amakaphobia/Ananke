{ config, lib, ... }:
let
  cfg = config.ananke.desktop.profiles;
in
{
  imports = [
    ../../modules/hypr
    ../../modules/screenshot.nix
    ../../modules/firefox.nix
  ];

  options.ananke.desktop.profiles.hypr = {
    enable = lib.mkEnableOption "Enable this hyprland powered desktop profile";
  };

  config = lib.mkIf cfg.hypr.enable {
    ananke.desktop = {
      hypr.enable = lib.mkDefault true;
      screenshot.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
    };

    # other desktop programs here
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.desktop;
in
{
  imports = [
    ../../modules/system/desktop/audio.nix
    ../../modules/system/desktop/display-manager/ly.nix
    ../../modules/system/desktop/window-manager/hyprland.nix

    ../../modules/system/programs/firefox.nix
    ../../modules/system/programs/thunar.nix
  ];

  options.ananke.profiles.system.desktop = {
    enable = lib.mkEnableOption "Basic desktop profile";
  };

  config = lib.mkIf cfg.enable {
    ananke.system = {
      displayManager.ly.enable = lib.mkDefault true;
      windowManager.hypr.enable = lib.mkDefault true;
      audio.pipewire.enable = lib.mkDefault true;

      programs = {
        firefox.enable = lib.mkDefault true;
        thunar.enable = lib.mkDefault true;
      };
    };
  };
}

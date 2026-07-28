{ config, lib, ... }:
let
  cfg = config.ananke.system.desktop;
in
{
  imports = [
    ../../modules/desktop/audio.nix
    ../../modules/desktop/display-manager/ly.nix
    ../../modules/desktop/window-manager/hyprland.nix

    ../../modules/programs/firefox.nix
    ../../modules/programs/thunar.nix
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

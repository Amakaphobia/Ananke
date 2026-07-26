{ lib, ... }:
{
  imports = [
    ../modules/desktop/audio.nix
    ../modules/desktop/display-manager/ly.nix
    ../modules/desktop/window-manager/hyprland.nix

    ../modules/programs/firefox.nix
    ../modules/programs/thunar.nix
  ];

  config = {
    ananke.system = {
      windowManager.hypr.enable = lib.mkDefault true;
      programs.firefox.enable = lib.mkDefault true;
    };
  };
}

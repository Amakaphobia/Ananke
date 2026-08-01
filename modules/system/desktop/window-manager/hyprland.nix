{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.system.desktop.windowManager.hypr;
in
{
  options.ananke.system.desktop.windowManager.hypr = {
    enable = lib.mkEnableOption "Install hyprland and its needed services on the system";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    security = {
      # Set the rights for hyprlands hyprlock
      pam.services.hyprlock = { };
      # polkit is used for auth
      polkit.enable = true;
    };

    #Hyprland Portals
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
  };
}

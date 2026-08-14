{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.desktop.hypr;
in
{
  imports = [
    ./land
  ];

  config.wayland.windowManager.hyprland = lib.mkIf cfg.enable {
    enable = lib.mkDefault true; # Enable home manager module for hyprland

    # hyprland is already owned by config.nix at system level:
    package = null;
    portalPackage = null;

    # remove ambiguity
    configType = "lua";
  };
}

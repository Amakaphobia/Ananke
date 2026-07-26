{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.hypr;
in
{
  # hypr ecosystem:
  imports = [
    ./land.nix
    ./idle.nix
    ./paper.nix
    ./lock.nix
  ];

  # create a master switch and a hyprshutdown option
  options.ananke.desktop.hypr = {
    enable = lib.mkEnableOption "The ananke Hypr ecosystem";

    shutdown.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "wether hyprshutdown should be installed";
    };

    polkit.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "wether hyprpolkit should be installed";
    };

  };

  # use hyprpolkit by default
  services.hyprpolkitagent.enable = lib.mkIf (cfg.enable && cfg.polkit.enable);

  #install hyprshutdown alongside hypr by default
  config = lib.mkIf cfg.enable {
    home.packages = lib.optional cfg.shutdown.enable pkgs.hyprshutdown;
  };
}

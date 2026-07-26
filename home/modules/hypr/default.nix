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
    shutdown.enable = lib.mkEnableOption "wether to install hyprshutdown";
    polkitAgent.enable = lib.mkEnableOption "wether to enable hyprplokitagent";
  };

  config = lib.mkIf cfg.enable {

    # use hyprpolkit by default
    services.hyprpolkitagent.enable = cfg.polkitAgent.enable;
    # install hyprshutdown alongside hypr by default
    home.packages = lib.optional cfg.shutdown.enable pkgs.hyprshutdown;

    # set default packages from the hypr ecosystem
    cfg = {
      shutdown.enable = lib.mkDefault true;
      polkitAgent.enable = lib.mkDefault true;
      idle.enable = lib.mkDefault true;
      lock.enable = lib.mkDefault true;
      paper.enable = lib.mkDefault true;
    };
  };
}

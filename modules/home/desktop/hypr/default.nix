{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.hypr;
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
  options.ananke.home.desktop.hypr = {
    enable = lib.mkEnableOption "The ananke Hypr ecosystem";
    shutdown.enable = lib.mkEnableOption "hyprshutdown";
    polkitAgent.enable = lib.mkEnableOption "hyprpolkitagent";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.system.desktop.windowManager.hypr.enable;
        message = "Hyprland needs to be installed on system level, add: ananke.system.desktop.windowManager.hypr.enable";
      }
    ];

    # set default packages from the hypr ecosystem
    ananke.home.desktop.hypr = {
      shutdown.enable = lib.mkDefault true;
      polkitAgent.enable = lib.mkDefault true;
      idle.enable = lib.mkDefault true;
      lock.enable = lib.mkDefault true;
      paper.enable = lib.mkDefault true;
    };

    # enable hyprpolkit
    services.hyprpolkitagent.enable = cfg.polkitAgent.enable;
    # install hyprshutdown
    home.packages = lib.optional cfg.shutdown.enable pkgs.hyprshutdown;

  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.system.desktop.displayManager.ly;
in
{
  options.ananke.system.desktop.displayManager.ly = {
    enable = lib.mkEnableOption "ly";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.ly.enable = true;
  };
}

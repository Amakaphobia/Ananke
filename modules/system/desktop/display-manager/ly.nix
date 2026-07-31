{ config, lib, ... }:
let
  cfg = config.ananke.system.displayManager.ly;
in
{
  options.ananke.system.displayManager.ly = {
    enable = lib.mkEnableOption "ly";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.ly.enable = true;
  };
}

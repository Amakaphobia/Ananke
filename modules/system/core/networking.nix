{ config, lib, ... }:
let
  cfg = config.ananke.system.core.networking;
in
{
  options.ananke.system.core.networking = {
    enable = lib.mkEnableOption "networking";
  };
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}

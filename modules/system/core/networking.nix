{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.core.networking;
in
{
  options.ananke.profiles.system.core.networking = {
    enable = lib.mkEnableOption "networking";
  };
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}

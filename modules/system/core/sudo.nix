{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.core.sudo;
in
{
  options.ananke.profiles.system.core.sudo = {
    enable = lib.mkEnableOption "sudo configuration";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };
}

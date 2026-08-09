{ config, lib, ... }:
let
  cfg = config.ananke.system.core.sudo;
in
{
  options.ananke.system.core.sudo = {
    enable = lib.mkEnableOption "sudo configuration";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };
}

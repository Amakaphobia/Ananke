{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.desktop.programs.kde.connect;
in
{
  options.ananke.profiles.system.desktop.programs.kde.connect = {
    enable = lib.mkEnableOption "Kde Connect";
  };

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}

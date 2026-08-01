{ config, lib, ... }:
let
  cfg = config.ananke.system.desktop.programs.thunar;
in
{
  options.ananke.system.desktop.programs.thunar = {
    enable = lib.mkEnableOption "Install Thunar";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      thunar.enable = true;
      xfconf.enable = true;
    };
    services = {
      # user level file system Integration (trash, mounts, remote drives)
      gvfs.enable = true;
      # thumbnails
      tumbler.enable = true;
    };
  };
}

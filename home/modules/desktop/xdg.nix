{ config, lib, ... }:
let
  cfg = config.ananke.desktop.xdgMimeApps;
in
{
  options.ananke.desktop.xdgMimeApps = {
    enable = lib.mkEnableOption "Sets preffered applications";
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];
      };
    };
  };
}

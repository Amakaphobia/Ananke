{ config, lib, ... }:
let
  cfg = config.ananke.home.desktop.xdgMimeApps;
in
{
  options.ananke.home.desktop.xdgMimeApps = {
    enable = lib.mkEnableOption "prefered applications";
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

{ config, lib, ... }:
let
  cfg = config.ananke.home.desktop.xdgMimeApps;
  applications = {
    browser = [ "firefox.desktop" ];
    imageViewer = [ "imv.desktop" ];
  };

  mimeTypes = {
    browser = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];

    image = [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/svg+xml"
    ];
  };
in
{
  options.ananke.home.desktop.xdgMimeApps = {
    enable = lib.mkEnableOption "prefered applications";
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications =
        lib.genAttrs mimeTypes.browser (_: applications.browser)
        // lib.genAttrs mimeTypes.image (_: applications.imageViewer);
    };
  };
}

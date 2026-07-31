{ config, lib, ... }:
let
  ff = config.ananke.desktop.firefox;
  cfg = ff.webapps.excalidraw;
in
{
  options.ananke.desktop.firefox.webapps.excalidraw = {
    enable = lib.mkEnableOption "Excalidraw";
  };

  config = lib.mkIf (ff.enable && ff.webapps.enable && cfg.enable) {
    programs.firefox = {
      profiles.excalidraw = {
        id = 1;
        isDefault = false;

        settings = {
          # allow custom stylsheets
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # do not become default
          "browser.shell.checkDefaultBrowser" = false;
        };

        userChrome = ''
          /* hide bars and tabs*/
          #titlebar,
          #navigator-toolbox{
            display:none !important;
          }
          /*hide url preview when hovering links*/
          #statuspanel {
            display: none !important;
          }
        '';
      };
    };

    xdg.desktopEntries.excalidraw = {
      name = "Excalidraw";
      genericName = "Whiteboard";
      comment = "Open Excalidraw as a standalone web application";

      # execute firefox (-P selects profile) --name,--class sets window class for wayland or x11, new window and the url
      exec = "firefox -P excalidraw --name excalidraw --class excalidraw --new-window https://excalidraw.com";

      icon = ../../../../../assets/icons/excalidraw.svg;

      terminal = false;

      categories = [
        "Graphics"
        "Office"
      ];

      settings = {
        StartupWMClass = "excalidraw";
        Keywords = "whiteboard;drawing;diagram;";
      };
    };

  };
}

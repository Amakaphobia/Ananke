{ config, lib, ... }:
let
  cfg = config.ananke.desktop.hypr;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    # environment variables
    env = [
      {
        _args = [
          "GDK_BACKEND"
          "wayland,X11,*"
        ];
      }
      {
        _args = [
          "XDG_CURRENT_DESKTOP"
          "Hyprland"
        ];
      }
      {
        _args = [
          "XDG_SESSION_TYPE"
          "wayland"
        ];
      }
      {
        _args = [
          "XDG_SESSION_DESKTOP"
          "Hyprland"
        ];
      }
    ];

    # Monitor

    monitor = {
      output = "";
      mode = "preferred";
      position = "0x0";
      scale = 1;
    };

    # Layout
    config = {
      # default layout is scrolling
      general.layout = "scrolling";

      # define available layouts
      master = {
        orientation = "left";
      };

      scrolling = {
        fullscreen_on_one_column = true;
      };

      # disable the default things
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
  };
}

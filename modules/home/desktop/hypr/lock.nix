{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.home.desktop.hypr;
  colorsLib = import (paths.lib + "/colors.nix") {
    inherit lib;
  };
  theme = config.ananke.theme;
  colors = theme.scheme.roles;
  font_family = theme.fonts.sansSerif.name;
  font_color = colorsLib.hyprRgb colors.foreground;
  clock_color = colorsLib.hyprRgba colors.accentAlt "99";
in
{
  options.ananke.home.desktop.hypr.lock = {
    enable = lib.mkEnableOption "wether to install hyprlock";
  };

  config = lib.mkIf (cfg.enable && cfg.lock.enable) {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint, 0.23, 1, 0.32, 1"
          ];

          animation = [
            "fadeIn, 1, 3, easeOutQuint"
            "fadeOut, 1, 3, easeOutQuint"
          ];
        };
        background = [
          {
            monitor = "";
            path = "${theme.images.lockscreen}";
          }
        ];

        shape = [
          {
            monitor = "";

            size = "380, 170";
            position = "0, 300";
            halign = "center";
            valign = "center";

            # Slightly tinted glass-like background.
            color = colorsLib.hyprRgba colors.background "55";

            # Semi-transparent accent border.
            border_size = 2;
            border_color = colorsLib.hyprRgba colors.accent "99";
            rounding = 24;

            shadow_passes = 3;
            shadow_size = 8;
            shadow_color = colorsLib.hyprRgba colors.background "99";

            zindex = 0;
          }
        ];
        label = [
          {
            text = "cmd[update:1000] date +'%H:%M'";

            halign = "center";
            valign = "center";
            text_align = "center";
            position = "0, 325";
            monitor = "";

            inherit font_family;
            color = clock_color;
            font_size = 64;

            shadow_passes = 2;
            shadow_size = 4;

            zindex = 1;
          }

          {
            text = "cmd[update:60000] date +'%A, %B %-d'";

            halign = "center";
            valign = "center";
            text_align = "center";
            position = "0, 265";
            monitor = "";

            inherit font_family;
            color = clock_color;
            font_size = 20;

            shadow_passes = 1;

            zindex = 1;
          }
        ];

        input-field = [
          {
            size = "200, 50";

            halign = "center";
            valign = "center";
            position = "0, -10%";
            monitor = "";

            dots_center = true;
            fade_on_empty = true;

            inherit font_family font_color;
            inner_color = colorsLib.hyprRgb colors.background;
            outer_color = colorsLib.hyprRgb colors.accent;

            outline_thickness = 5;
            placeholder_text = "Speak Friend and enter";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}

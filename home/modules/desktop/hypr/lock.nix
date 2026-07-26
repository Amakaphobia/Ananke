{ config, lib, ... }:
let
  cfg = config.ananke.desktop.hypr;
  colorsLib = import ../../../lib/colors.nix {
    inherit lib;
  };
  colors = config.dave.theme.scheme.roles;
in
{
  options.ananke.desktop.hypr.lock = {
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
            path = "${config.dave.theme.images.lockscreen}";
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
            fade_on_empty = false;

            font_family = config.dave.theme.fonts.sansSerif.name;
            font_color = colorsLib.hyprRgb colors.foreground;
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

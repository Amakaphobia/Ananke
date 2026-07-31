{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.ananke.desktop.hypr;

  colorsLib = import "${self}/lib/colors.nix" {
    inherit lib;
  };
  colors = config.ananke.modules.theme.scheme.roles;

  border1 = colorsLib.hyprRgba colors.accent "ff";
  border2 = colorsLib.hyprRgba colors.info "ff";
  borderInactive = colorsLib.hyprRgba colors.surface "dd";
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    config = {
      general = {
        # Gaps
        gaps_in = 3;
        gaps_out = 8;

        # border
        border_size = 2;
        col = {
          active_border = {
            colors = [
              border2
              border1
            ];
            angle = 90;
          };
          inactive_border = borderInactive;
        };
        resize_on_border = false;
        allow_tearing = false;
      };

      decoration = {

        # make edges round
        rounding = 7;
        rounding_power = 2;

        # set opacity (can be overridden by window Rules)
        active_opacity = 0.9;
        inactive_opacity = 0.9;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

        # dim when scratchpad is open
        dim_special = 0.4;
      };
    };
  };
}

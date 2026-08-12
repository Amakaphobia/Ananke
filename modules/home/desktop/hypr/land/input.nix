{ config, lib, ... }:
let
  cfg = config.ananke.home.desktop.hypr;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    config = {
      input = {
        kb_layout = "ananke-de";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        # -- 0 -> click to focus
        # -- 1 -> window under cursor is focused
        # -- 2 -> keyboard and mouse focus are seperate; clicking changes keyboard focus
        # -- 3 -> keyboard and mouse focus are seperate
        follow_mouse = 2;

        # -- -1.0 - 1.0, 0 means no modification.
        sensitivity = 0;

        # make touchpad less annoying
        touchpad = {
          tap_to_click = false;
          natural_scroll = false;
          disable_while_typing = true;
        };
      };
    };
  };
}

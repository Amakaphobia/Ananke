{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.blink-cmp = {
      enable = true;
      settings.keymap = {
        preset = "super-tab";
        "<C-j>" = [
          "select_next"
          "fallback"
        ];

        "<C-k>" = [
          "select_prev"
          "fallback"
        ];

        "<C-n>" = false;
        "<C-p>" = false;
      };
    };
  };
}

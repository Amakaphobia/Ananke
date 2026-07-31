{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          transparent_background = true;
          float.transparent = true;
        };
      };
    };
  };
}

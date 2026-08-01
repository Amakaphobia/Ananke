{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.which-key = {
      enable = true;

      settings.plugins.presets.nav = false;
    };
  };
}

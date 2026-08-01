{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.mini-pairs = {
      enable = true;

      settings.modes = {
        insert = true;
        command = true;
        terminal = false;
      };
    };
  };
}

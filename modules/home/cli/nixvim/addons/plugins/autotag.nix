{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.ts-autotag = {
      enable = true;

      settings.opts = {
        enable_close = true;
        enable_close_on_slash = false;
        enable_rename = true;
      };
    };
  };
}

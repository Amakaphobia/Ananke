{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.mini-pairs = {
      enable = true;

      settings = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
        mappings = {
          # only insert } when next char is not in (letter, number, underscore)
          "{" = {
            neigh_pattern = "^[^\\\\][^%w_]";
          };
        };
      };
    };
  };
}

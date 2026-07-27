{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    # enables smart surrounding of text
    programs.nixvim.plugins.mini-surround = {
      enable = true;

      settings.mappings = {
        add = "gsa";
        delete = "gsd";
        find = "gsf";
        find_left = "gsF";
        highlight = "gsh";
        replace = "gsr";

        # these can be appended before the actual surrounding character to target the next or previous matching surround element
        suffix_last = "l";
        suffix_next = "n";
      };
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.diagnostic.settings = {
      virtual_text = {
        current_line = true;
        spacing = 2;
        source = "if_many";
        virt_text_pos = "right_align";
      };

      virtual_lines = false;

      severity_sort = true;
      update_in_insert = false;
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim.plugins.colorizer = {
      enable = true;

      settings = {
        filetypes = {
          __unkeyed-1 = "*";
          __unkeyed-2 = "!vim";

        };
        options = {
          parsers = {
            css = true;
            names.enable = false;
            tailwind = {
              enable = true;
              lsp = true;
            };
          };

          display = {
            mode = "virtualtext";

            virtualtext = {
              char = "■";
              position = "after";
            };
          };
        };
      };
    };
  };
}

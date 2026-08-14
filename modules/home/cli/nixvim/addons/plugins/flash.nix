{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    programs.nixvim = {
      plugins.flash = {
        enable = true;

        settings.modes.char.enabled = false;
      };

      keymaps = [
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "s";
          action.__raw = ''
            function()
              require("flash").jump()
            end
          '';
          options.desc = "Flash jump";
        }
      ];
    };
  };
}

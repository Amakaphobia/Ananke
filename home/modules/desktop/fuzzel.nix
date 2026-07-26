{ config, lib, ... }:
let
  cfg = config.ananke.desktop.fuzzel;
  theme = config.dave.theme;
  colors = theme.scheme.roles;
in
{
  options.ananke.desktop.fuzzel = {
    enable = lib.mkEnableOption "Enable fuzzel";
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          width = 50;
          lines = 10;
        };

        colors.selection = lib.mkForce "${colors.background}ff";

        border = {
          width = 2;
          radius = 12;
        };
      };
    };
  };
}

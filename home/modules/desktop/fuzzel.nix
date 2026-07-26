{ config, lib, ... }:
let
  cfg = config.anake.desktop.fuzzel;
  theme = config.dave.theme;
  colors = theme.scheme.roles;
in
{
  options.anake.desktop.fuzzel = {
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

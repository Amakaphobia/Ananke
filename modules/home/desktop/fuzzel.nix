{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.desktop.fuzzel;
  theme = config.ananke.profiles.home.theme;
  colors = theme.scheme.roles;
in
{
  options.ananke.profiles.home.desktop.fuzzel = {
    enable = lib.mkEnableOption "Fuzzel";
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

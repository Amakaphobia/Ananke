{ pkgs, paths, ... }:
let
  fonts = import (paths.lib + "/fontCatalog.nix") { inherit pkgs; };
  interfaceSans = fonts.mapleMono;
  interfaceSerif = fonts.lora;
  interfaceMono = fonts.jetBrainsMono;
  interfaceEmoji = fonts.notoEmoji;
in
{

  ananke.modules.theme = {
    polarity = "dark";
    scheme = import (paths.themes + "/catppuccin-mocha.nix");

    images = {
      wallpaper = paths.wallpaper + "/waifu/AngelBlue.png";
      lockscreen = paths.wallpaper + "/waifu/purplegirl.jpeg";
    };

    fonts = {
      sansSerif = interfaceSans;
      serif = interfaceSerif;
      monospace = interfaceMono;
      emoji = interfaceEmoji;

      sizes = {
        desktop = 10;
        applications = 10;
        terminal = 11;
        popups = 10;

      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 24;
    };

    icons = {
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}

{
  config,
  lib,
  pkgsUnstable,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.media.spotify-player;

  theme = config.ananke.profiles.home.theme;
  colors = theme.scheme.roles;
  terminal = theme.scheme.terminal;

  hex = color: "#${color}";
in
{
  options.ananke.profiles.home.desktop.media.spotify-player = {
    enable = lib.mkEnableOption "spotify-player";
  };

  config = lib.mkIf cfg.enable {
    programs.spotify-player = {
      enable = true;
      package = pkgsUnstable.spotify-player;
      settings = {
        theme = "Ananke";
      };

      themes = [
        {
          name = "Ananke";

          palette = {
            background = hex colors.background;
            foreground = hex colors.foreground;

            black = hex terminal.color0;
            red = hex terminal.color1;
            green = hex terminal.color2;
            yellow = hex terminal.color3;
            blue = hex terminal.color4;
            magenta = hex terminal.color5;
            cyan = hex terminal.color6;
            white = hex terminal.color7;

            bright_black = hex terminal.color8;
            bright_red = hex terminal.color9;
            bright_green = hex terminal.color10;
            bright_yellow = hex terminal.color11;
            bright_blue = hex terminal.color12;
            bright_magenta = hex terminal.color13;
            bright_cyan = hex terminal.color14;
            bright_white = hex terminal.color15;
          };
        }
      ];
    };
  };
}

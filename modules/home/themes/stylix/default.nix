{ config, ... }:
let
  theme = config.ananke.theme;
  colors = theme.scheme.roles;
  terminal = theme.scheme.terminal;
in
{
  imports = [ ./targets.nix ];

  config.stylix = {
    enable = true;
    autoEnable = false;

    inherit (theme) polarity fonts cursor;

    icons = {
      enable = true;
      inherit (theme.icons) package dark light;
    };

    base16Scheme = {
      scheme = theme.scheme.name;
      author = theme.scheme.author;

      base00 = colors.background;
      base01 = colors.surface;
      base02 = colors.selection;
      base03 = colors.border;
      base04 = colors.foregroundMuted;
      base05 = colors.foreground;
      base06 = colors.foreground;
      base07 = colors.foreground;

      base08 = colors.error;
      base09 = colors.accentAlt;
      base0A = colors.warning;
      base0B = colors.success;
      base0C = terminal.color6;
      base0D = colors.info;
      base0E = colors.accent;
      base0F = terminal.color1;
    };
  };
}

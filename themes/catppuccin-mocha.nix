let
  palette = {
    Rosewater = "f5e0dc";
    Flamingo = "f2cdcd";
    Pink = "f5c2e7";
    Mauve = "cba6f7";
    Red = "f38ba8";
    Maroon = "eba0ac";
    Peach = "fab387";
    Yellow = "f9e2af";
    Green = "a6e3a1";
    Teal = "94e2d5";
    Sky = "89dceb";
    Sapphire = "74c7ec";
    Blue = "89b4fa";
    Lavender = "b4befe";
    Text = "cdd6f4";
    Subtext1 = "bac2de";
    Subtext0 = "a6adc8";
    Overlay2 = "9399b2";
    Overlay1 = "7f849c";
    Overlay0 = "6c7086";
    Surface2 = "585b70";
    Surface1 = "45475a";
    Surface0 = "313244";
    Base = "1e1e2e";
    Mantle = "181825";
    Crust = "11111b";
  };
in
{
  name = "catppuccin-mocha";
  author = "catppuccin";

  inherit palette;

  roles = with palette; {

    # Neutral surfaces
    background = Crust;
    surface = Base;
    surfaceRaised = Surface0;
    overlay = Surface1;

    # Foreground content
    foregroundDisabled = Overlay1;
    foregroundMuted = Subtext0;
    foreground = Text;

    # Structure and focus
    border = Overlay2;
    focus = Lavender;

    # Interactive colors
    accent = Mauve;
    accentAlt = Peach;
    accentForeground = Mantle;
    selection = Sky;
    selectionForeground = Mantle;

    # Semantic status colors
    success = Green;
    warning = Yellow;
    error = Red;
    info = Blue;
  };

  # ANSI terminal palette. These names map directly to Kitty settings.
  terminal = with palette; {
    color0 = Base;
    color1 = Maroon;
    color2 = Green;
    color3 = Peach;
    color4 = Blue;
    color5 = Mauve;
    color6 = Teal;
    color7 = Overlay1;
    color8 = Surface2;
    color9 = Red;
    color10 = Teal;
    color11 = Yellow;
    color12 = Lavender;
    color13 = Pink;
    color14 = Sky;
    color15 = Subtext0;
  };
}

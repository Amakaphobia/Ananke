let
  makeColor = name: description: {
    inherit name description;
  };
  semanticColorRoles = [
    (makeColor "background" "default background for applications")
    (makeColor "surface" "default background for containers")
    (makeColor "surfaceRaised" "visually elevated containers")
    (makeColor "overlay" "Background for floating content such as menus popovers and tooltips.")
    (makeColor "foregroundDisabled" "very muted forground tone")
    (makeColor "foregroundMuted" "muted forground tone")
    (makeColor "foreground" "default tone for text")
    (makeColor "border" "default border tone")
    (makeColor "focus" "default border tone for focused objects")
    (makeColor "accent" "default accent color")
    (makeColor "accentAlt" "alternative accent color")
    (makeColor "accentForeground" "foreground accent color")
    (makeColor "selection" "default selection color")
    (makeColor "selectionForeground" "default selection foreground")
    (makeColor "success" "indicates success")
    (makeColor "warning" "indicates a non critical problem")
    (makeColor "error" "indicates a critical problem")
    (makeColor "info" "indicates noteworthy information")
  ];

  terminalColorRoles = [
    #  normal
    (makeColor "color0" "black")
    (makeColor "color1" "red")
    (makeColor "color2" "green")
    (makeColor "color3" "yellow")
    (makeColor "color4" "blue")
    (makeColor "color5" "magenta")
    (makeColor "color6" "cyan")
    (makeColor "color7" "light-grey")
    #  bright
    (makeColor "color8" "dark-grey")
    (makeColor "color9" "bright-red")
    (makeColor "color10" "bright-green")
    (makeColor "color11" "bright-yellow")
    (makeColor "color12" "bright-blue")
    (makeColor "color13" "bright-magenta")
    (makeColor "color14" "bright-cyan")
    (makeColor "color15" "bright-white")
  ];
in
{
  inherit semanticColorRoles terminalColorRoles;
}

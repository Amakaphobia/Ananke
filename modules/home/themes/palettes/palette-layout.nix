let
  semanticColorRoles = [
    {
      name = "background";
      description = "default background for applications";
    }
    {
      name = "surface";
      description = "default background for containers";
    }
    {
      name = "surfaceRaised";
      description = "visually elevated containers";
    }
    {
      name = "overlay";
      description = "Background for floating content such as menus; popovers and tooltips.";
    }
    {
      name = "foregroundDisabled";
      description = "very muted forground tone";
    }
    {
      name = "foregroundMuted";
      description = "muted forground tone";
    }
    {
      name = "foreground";
      description = "default tone for text";
    }
    {
      name = "border";
      description = "default border tone";
    }
    {
      name = "focus";
      description = "default border tone for focused objects";
    }
    {
      name = "accent";
      description = "default accent color";
    }
    {
      name = "accentAlt";
      description = "alternative accent color";
    }
    {
      name = "accentForeground";
      description = "foreground accent color";
    }
    {
      name = "selection";
      description = "default selection color";
    }
    {
      name = "selectionForeground";
      description = "default selection foreground";
    }
    {
      name = "success";
      description = "indicates success";
    }
    {
      name = "warning";
      description = "indicates a non critical problem";
    }
    {
      name = "error";
      description = "indicates a critical problem";
    }
    {
      name = "info";
      description = "indicates noteworthy information";
    }

  ];

  terminalColorRoles = [
    #  normal
    {
      name = "color0";
      description = "black";
    }
    {
      name = "color1";
      description = "red";
    }
    {
      name = "color2";
      description = "green";
    }
    {
      name = "color3";
      description = "yellow";
    }
    {
      name = "color4";
      description = "blue";
    }
    {
      name = "color5";
      description = "magenta";
    }
    {
      name = "color6";
      description = "cyan";
    }
    {
      name = "color7";
      description = "light-grey";
    }
    #  bright
    {
      name = "color8";
      description = "dark-grey";
    }
    {
      name = "color9";
      description = "bright-red";
    }
    {
      name = "color10";
      description = "bright-green";
    }
    {
      name = "color11";
      description = "bright-yellow";
    }
    {
      name = "color12";
      description = "bright-blue";
    }
    {
      name = "color13";
      description = "bright-magenta";
    }
    {
      name = "color14";
      description = "bright-cyan";
    }
    {
      name = "color15";
      description = "bright-white";
    }
  ];
in
{
  inherit semanticColorRoles terminalColorRoles;
}

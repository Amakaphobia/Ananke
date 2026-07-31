{ lib }:

rec {
  # Outputscolor as #hexadecimal value
  hex = color: "#${color}";

  # Used by Hyprland.
  hyprRgb = color: "rgb(${color})";

  # Alpha must be a two-character hexadecimal value:
  # "ff" = opaque, "00" = transparent
  hyprRgba = color: alpha: "rgba(${color}${alpha})";

  # Convert an attribute set into GTK CSS color declarations.
  #   accent = "cba6f7";
  #   @define-color accent #cba6f7;
  toGtkCss =
    colors:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: color: "@define-color ${name} ${hex color};") colors
    );

  # Kitty's settings use ordinary #rrggbb strings.
  toKitty = colors: lib.mapAttrs (_name: color: hex color) colors;
}

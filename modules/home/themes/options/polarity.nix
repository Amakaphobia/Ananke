{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # light or dark
  options.ananke.modules.theme.polarity = mkOption {
    type = types.enum [
      "light"
      "dark"
    ];
    description = "is the selected theme light or dark";
  };
}

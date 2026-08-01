{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.ananke.theme.icons = mkOption {
    description = "Desktop icon theme.";

    type = types.submodule {
      options = {
        package = mkOption {
          description = "Icon Package";
          type = types.package;
        };

        dark = mkOption {
          description = "Dark Theme";
          type = types.str;
        };

        light = mkOption {
          description = "Light Theme";
          type = types.str;
        };
      };
    };
  };
}

{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # cursor
  options.ananke.theme.cursor = mkOption {
    description = "Desktop cursor theme.";

    type = types.submodule {
      options = {
        package = mkOption {
          type = types.package;
          description = "The package";
        };
        name = mkOption {
          type = types.str;
          description = "the name of the cursor";
        };
        size = mkOption {
          type = types.ints.positive;
          description = "the cursor size";
        };
      };
    };
  };
}

{ lib, ... }:
let
  inherit (lib) mkOption types;
  fontOptions = lib.genAttrs [ "serif" "sansSerif" "monospace" "emoji" ] (
    name:
    mkOption {
      description = "Default font for: ${name}";
      type = types.submodule {
        options = {
          package = mkOption {
            type = types.package;
          };
          name = mkOption {
            type = types.str;
          };
        };
      };
    }
  );

  sizeOptions = lib.genAttrs [ "desktop" "applications" "terminal" "popups" ] (
    name:
    mkOption {
      type = types.ints.positive;
      description = "default size for ${name}";
    }
  );
in
{
  # create font options
  options.ananke.modules.theme.fonts = mkOption {
    description = "Font families used by the desktop.";

    type = types.submodule {
      options = fontOptions // {
        sizes = mkOption {
          description = "Semantic font sizes.";

          type = types.submodule {
            options = sizeOptions;
          };
        };
      };
    };
  };

}

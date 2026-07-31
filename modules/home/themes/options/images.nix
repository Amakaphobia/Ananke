{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # create user options for wallpaper and lockscreen
  options.ananke.modules.theme.images = mkOption {
    description = "images used by the theme";
    type = types.submodule {

      options = {
        wallpaper = mkOption {
          type = types.path;
          description = "Wallpaper";
        };

        lockscreen = mkOption {
          type = types.path;
          description = "Lockscreen";
        };
      };
    };
  };
}

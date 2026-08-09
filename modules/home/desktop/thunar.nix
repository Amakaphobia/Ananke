{
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.ananke.home.desktop.thunar;
in
{
  options.ananke.home.desktop.thunar = {
    enable = lib.mkEnableOption "Configure thunar for user";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.system.desktop.programs.thunar.enable;
        message = "Thunar needs to be installed at system level. -> config.ananke.system.desktop.programs.thunar.enable = true;";
      }
    ];
    xfconf.settings.thunar = {
      # look
      "default-view" = "ThunarIconView";
      "misc-text-beside-icons" = true;
      "misc-highlighting-enabled" = false;
      "misc-thumbnail-draw-frames" = false;
      # behavior
      "misc-middle-click-in-tab" = true;
      "misc-show-delete-action" = true;
      "misc-single-click" = false;
    };
  };
}

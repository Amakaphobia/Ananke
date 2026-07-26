{
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.ananke.desktop.thunar;
in
{
  options.ananke.desktop.thunar = {
    enable = lib.mkEnableOption "Configure thunar for user";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.system.programs.thunar.enable;
        message = "Fuzzel needs to be installed at system level. -> config.ananke.system.programs.thunar.enable = true;";
      }
    ];
    xfconf.settings.thunar = {
      "misc-highlighting-enabled" = false;
    };
  };
}

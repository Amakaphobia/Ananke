{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.ananke.home.desktop.firefox;
in
{
  imports = [
    ./profile.nix
    ./webapps
  ];
  options.ananke.home.desktop.firefox = {
    enable = lib.mkEnableOption "Firefox profile";
    webapps = {
      enable = lib.mkEnableOption "Webapps";

    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.system.desktop.programs.firefox.enable;
        message = "Firefox needs to be installed at system level, add config.ananke.system.programs.firefox.enable";
      }
    ];

    programs.firefox = {
      enable = true;

      # firefox is installed on system level
      package = null;

    };
  };
}

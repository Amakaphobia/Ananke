{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.firefox;
in
{
  imports = [
    ./profile.nix
    ./webapps
  ];
  options.ananke.profiles.home.desktop.firefox = {
    enable = lib.mkEnableOption "Firefox profile";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.ananke.profiles.system.desktop.programs.firefox.enable;
        message = "Firefox needs to be installed at system level, add config.ananke.profiles.system.desktop.programs.firefox.enable";
      }
    ];

    programs.firefox = {
      enable = true;

      # firefox is installed on system level
      package = null;

    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.home.desktop.thunderbird;
in
{
  options.ananke.home.desktop.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;

      policies = {
        # no telemetry for me
        DisableTelemetry = true;
      };
    };
  };
}

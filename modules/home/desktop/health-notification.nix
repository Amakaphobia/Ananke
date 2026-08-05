{
  config,
  lib,
  pkgs,
  paths,
  ...
}:
let
  cfg = config.ananke.home.desktop.services.serviceCheck;

  serviceCheck = pkgs.writeShellApplication {
    name = "service-check";

    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnused
      libnotify
      systemd
      wl-clipboard
    ];

    text = builtins.readFile (paths.scripts + "/services/service-check.sh");
  };
in
{
  options.ananke.home.desktop.services.serviceCheck = {
    enable = lib.mkEnableOption "Perically Check System Health";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ serviceCheck ];

    systemd.user.services.serviceCheck = {
      Unit = {
        Description = "Check for failed systemd units";
      };

      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe serviceCheck;
      };
    };

    systemd.user.timers.serviceCheck = {
      Unit = {
        Description = "Periodically check service health";
      };

      Timer = {
        # Relative to the start of the user systemd manager,
        # which normally corresponds to beginning the user session.
        OnStartupSec = "2m";

        # Run again five minutes after the previous activation.
        OnUnitActiveSec = "5m";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}

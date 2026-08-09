{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.ananke.home.desktop.kdeconnect;

  # build the correct path to the device's files
  kdeconnectThunar = pkgs.writeShellApplication {
    name = "kdeconnect-thunar";

    runtimeInputs = [
      pkgs.systemd
      pkgs.gnugrep
      pkgs.coreutils
      pkgs.thunar
    ];

    text = ''
      uri="''${1:-}"

      if [[ -z "$uri" ]]; then
        echo "Usage: kdeconnect-thunar kdeconnect://DEVICE_ID/" >&2
        exit 1
      fi

      # kdeconnect://781bdc.../
      device_id="''${uri#kdeconnect://}"
      device_id="''${device_id%%/*}"

      if [[ ! "$device_id" =~ ^[A-Za-z0-9._-]+$ ]]; then
        echo "Invalid KDE Connect device ID: $device_id" >&2
        exit 1
      fi

      object_path="/modules/kdeconnect/devices/$device_id/sftp"

      response="$(
        busctl --user call \
          org.kde.kdeconnect \
          "$object_path" \
          org.kde.kdeconnect.device.sftp \
          getDirectories
      )"

      mapfile -t directories < <(
        printf '%s\n' "$response" \
          | grep -o '"[^"]*"' \
          | tr -d '"' \
          | grep -F "$XDG_RUNTIME_DIR/$device_id/"
      )

      if (( ''${#directories[@]} == 0 )); then
        echo "KDE Connect reported no browsable directories for $device_id" >&2
        exit 1
      fi

      thunar "''${directories[@]}"
    '';
  };

in
{
  options.ananke.home.desktop.kdeconnect = {
    enable = lib.mkEnableOption "KDE Connect desktop integration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      kdeconnectThunar
    ];

    # handle the browse file function in thunar by default
    xdg.desktopEntries.kdeconnect-thunar = {
      name = "KDE Connect (Thunar)";
      comment = "Browse KDE Connect devices with Thunar";

      exec = "${kdeconnectThunar}/bin/kdeconnect-thunar %u";

      terminal = false;
      noDisplay = true;

      mimeType = [
        "x-scheme-handler/kdeconnect"
      ];
    };

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/kdeconnect" = [
          "kdeconnect-thunar.desktop"
        ];
      };
    };

    # start as a service on startup
    systemd.user.services.kdeconnect = {
      Unit = {
        Description = "KDE Connect daemon";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe' pkgs.kdePackages.kdeconnect-kde "kdeconnectd";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}

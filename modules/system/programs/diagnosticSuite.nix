{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.system.programs.diagnosticSuite;
in
{
  options.ananke.system.programs.diagnosticSuite = {
    enable = lib.mkEnableOption "System diagnostic tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Processes, open files, and system calls
      lsof
      strace

      # Network and DNS inspection
      dnsutils

      # Hardware discovery
      pciutils
      usbutils

      # Storage health
      smartmontools

      # Temperatures and hardware sensors
      lm_sensors
    ];
  };
}

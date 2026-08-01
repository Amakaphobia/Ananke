{ lib, config, ... }:
let
  cfg = config.ananke.hardware.laptop.hibernation;
in
{
  options.ananke.hardware.laptop.hibernation = {
    enable = lib.mkEnableOption "hibernation";
    hibernateDelaySeconds = lib.mkOption {
      type = lib.types.ints.positive;
      default = 600;
      description = "Time in seconds until hibernation. defaults to 600.";
    };
    hibernateOnAc = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the machine should enter hibernation while connected to AC power. Defaults to true.";
    };
  };

  config = lib.mkIf cfg.enable {
    # enter hibernation after suspension
    systemd.sleep.settings.Sleep = {
      # enter hibernation after amount of time specified in suspension
      HibernateDelaySec = "${toString cfg.hibernateDelaySeconds}s";
      # keep timer on even when laptop is charging
      HibernateOnACPower = cfg.hibernateOnAc;
    };
  };
}

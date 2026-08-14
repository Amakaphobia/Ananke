{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.system.health;
in
{
  imports = [
    (paths.modules + "/system/hardware/firmware.nix")
    (paths.modules + "/system/hardware/storage-health.nix")
  ];

  options.ananke.profiles.system.health = {
    enable = lib.mkEnableOption "System Health Profile";
  };

  config = lib.mkIf cfg.enable {
    ananke.profiles = {
      hardware = {
        # disabled until I need it
        firmware.enable = lib.mkDefault false;
        storage-health.enable = lib.mkDefault true;
      };
    };
  };
}

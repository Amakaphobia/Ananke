{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.core.printing;
in
{
  options.ananke.profiles.system.core.printing = {
    enable = lib.mkEnableOption "printing";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.system.core.printing;
in
{
  options.ananke.system.core.printing = {
    enable = lib.mkEnableOption "printing";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}

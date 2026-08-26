{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.desktop.programs.bazecor;
in
{
  options.ananke.profiles.system.desktop.programs.bazecor = {
    enable = lib.mkEnableOption "Bazecor";
  };

  config = lib.mkIf cfg.enable {
    programs.bazecor.enable = true;
  };
}

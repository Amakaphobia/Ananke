{ config, lib, ... }:
let
  cfg = config.ananke.system.programs.git;
in
{
  options.ananke.system.programs.git = {
    enable = lib.mkEnableOption "git";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
      };
    };
  };
}

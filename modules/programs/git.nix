{ config, lib, ... }:
let
  cfg = config.ananke.system.git;
in
{
  options.ananke.system.git = {
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

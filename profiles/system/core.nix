{ config, lib, ... }:
let
  cfg = config.ananke.profiles.system.core;
in
{
  imports = [
    ../../modules/core
    ../../modules/programs/base.nix
    ../../modules/programs/git.nix
  ];

  options.ananke.profiles.system.core = {
    enable = lib.mkEnableOption "System Core";
  };

  config = lib.mkIf cfg.enable {
    ananke.system = {
      base.enable = true;
      git.enable = true;
    };
  };
}

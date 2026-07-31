{ config, lib, ... }:
let
  cfg = config.ananke.profiles.dev;
in
{
  imports = [
    ../../../home/modules/dev
  ];
  options.ananke.profiles.dev = {
    enable = lib.mkEnableOption "Dev tools";
  };

  config = lib.mkIf cfg.enable {
    config.ananke.modules.dev = {
      enable = lib.mkDefault true;

      # enable basic shell and nix tooling by default
      nix.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
    };
  };
}

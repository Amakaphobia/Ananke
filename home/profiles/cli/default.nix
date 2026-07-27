{ config, lib, ... }:
let
  cfg = config.ananke.profiles.cli.base;
in
{
  imports = [
    ../../modules/cli
  ];

  options.ananke.profiles.cli.base = {
    enable = lib.mkEnableOption "Default profile";
  };

  config = lib.mkIf cfg.enable {
    ananke.cli = {
      utilities.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      nixvim.enable = lib.mkDefault true;
      ssh-agent.enable = lib.mkDefault true;
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.ananke.home.cli.ssh-agent;
in
{
  options.ananke.home.cli.ssh-agent = {
    enable = lib.mkEnableOption "ssh-agent";
  };

  config = lib.mkIf cfg.enable {
    # enable ssh agent
    services.ssh-agent.enable = true;
    programs.ssh = {
      # generate SSH client configuration
      enable = true;
      enableDefaultConfig = false;
    };
  };
}

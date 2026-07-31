{ config, lib, ... }:
let
  cfg = config.ananke.cli.ssh-agent;
in
{
  options.ananke.cli.ssh-agent = {
    enable = lib.mkEnableOption "ssh-agent";
  };

  config = lib.mkIf cfg.enable {
    # enable ssh agent
    services.ssh-agent.enable = true;
    programs.ssh = {
      # generate SSH client configuration
      enable = true;
      enableDefaultConfig = false;
      settings."github.com" = {
        # git@github.com:owner/repo
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        # allow to remember key for 1 hour after first unlock
        AddKeysToAgent = "1h";
      };
    };
  };
}

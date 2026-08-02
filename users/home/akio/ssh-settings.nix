{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.ssh.akio;
in
{

  options.ananke.profiles.home.cli.ssh.akio = {
    enable = lib.mkEnableOption "akio's ssh settings";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.ananke.home.cli.ssh-agent.enable;
        message = "SSH is not installed. See: config.ananke.home.cli.ssh-agent.enable";
      }
    ];

    programs.ssh = {
      settings = {
        # Github
        "github.com" = {
          # git@github.com:owner/repo
          User = "git";
          HostName = "github.com";

          # get key from secret store
          IdentityFile = "/run/secrets/ssh/github-private";
          # do not try other known ssh keys
          IdentitiesOnly = true;
          # allow to remember key for 1 hour after first unlock
          AddKeysToAgent = "1h";
        };
      };
    };
  };

}

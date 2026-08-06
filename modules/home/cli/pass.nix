{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.cli.pass;
in
{
  options.ananke.home.cli.pass = {
    enable = lib.mkEnableOption "pass";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gpg.enable = true;

      password-store = {
        enable = true;

        settings = {
          # remove pw from clipboard after 30 secs
          PASSWORD_STORE_CLIP_TIME = "30";
        };
      };

      browserpass = {
        enable = true;
        browsers = [ "firefox" ];
      };
    };

    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;

      # I already have an agent responsible for ssh
      enableSshSupport = false;

      # Graphical prompt
      pinentry.package = pkgs.pinentry-qt;
    };

  };
}

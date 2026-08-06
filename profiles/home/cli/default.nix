{
  config,
  paths,
  lib,
  ...
}:
let
  cfg = config.ananke.profiles.home.cli.base;
in
{
  imports = [
    (paths.modules + "/home/cli")
  ];

  options.ananke.profiles.home.cli.base = {
    enable = lib.mkEnableOption "Default profile";
  };

  config = lib.mkIf cfg.enable {
    ananke.home.cli = {
      utilities.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      comma.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      nixvim.enable = lib.mkDefault true;
      pass.enable = lib.mkDefault true;
      ssh-agent.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
    };
  };
}

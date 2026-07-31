{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.system.core;
in
{
  imports = [
    (paths.modules + "/system/core")
    (paths.modules + "/system/programs/base.nix")
    (paths.modules + "/system/programs/git.nix")
  ];

  options.ananke.profiles.system.core = {
    enable = lib.mkEnableOption "System Core";
  };

  config = lib.mkIf cfg.enable {
    ananke.system = {
      core = {
        systemd.enable = lib.mkDefault true;
        locale.enable = lib.mkDefault true;
        networking.enable = lib.mkDefault true;
        nix.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;
      };
      programs = {
        base.enable = lib.mkDefault true;
        git.enable = lib.mkDefault true;
      };
    };
  };
}

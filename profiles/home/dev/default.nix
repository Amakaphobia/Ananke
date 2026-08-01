{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.dev;
in
{
  imports = [
    (paths.modules + "/home/dev")
  ];
  options.ananke.profiles.home.dev = {
    enable = lib.mkEnableOption "Dev tools";
  };

  config = lib.mkIf cfg.enable {
    ananke.home.dev = {
      # enable basic shell and nix tooling by default
      nix.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
    };
  };
}

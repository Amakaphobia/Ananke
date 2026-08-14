{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.profiles.home.dev.shell;
in
{
  options.ananke.profiles.home.dev.shell = {
    enable = lib.mkEnableOption "shell tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      shfmt
      shellcheck
    ];
  };
}

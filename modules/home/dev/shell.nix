{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.dev.shell;
in
{
  options.ananke.home.dev.shell = {
    enable = lib.mkEnableOption "shell tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      shfmt
      shellcheck
    ];
  };
}

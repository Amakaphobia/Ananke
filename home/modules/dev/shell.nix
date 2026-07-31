{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.modules.dev.shell;
in
{
  options.ananke.modules.dev.shell = {
    enable = lib.mkEnableOption "shell tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      shfmt
      shellcheck
    ];
  };
}

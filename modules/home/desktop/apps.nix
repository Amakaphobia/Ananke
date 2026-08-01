{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.apps;
in
{
  options.ananke.home.desktop.apps = {
    enable = lib.mkEnableOption "Apps";

    geany.enable = lib.mkEnableOption "Geany";
    gimp.enable = lib.mkEnableOption "Gimp";
    imv.enable = lib.mkEnableOption "imv";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.geany.enable pkgs.geany
      ++ lib.optional cfg.gimp.enable pkgs.gimp
      ++ lib.optional cfg.imv.enable pkgs.imv;
  };
}

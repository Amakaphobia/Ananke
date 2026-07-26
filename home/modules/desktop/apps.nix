{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.apps;
in
{
  options.ananke.desktop.apps = {
    enable = lib.mkEnableOption "Apps";

    geany.enable = lib.mkEnableOption "Geany";
    pastel.enable = lib.mkEnableOption "pastel";
    vlc.enable = lib.mkEnableOption "vlc";
    spotify.enable = lib.mkEnableOption "Spotify";
    gimp.enable = lib.mkEnableOption "Gimp";
    imv.enable = lib.mkEnableOption "imv";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.geany.enable pkgs.geany
      ++ lib.optional cfg.pastel.enable pkgs.pastel
      ++ lib.optional cfg.vlc.enable pkgs.vlc
      ++ lib.optional cfg.spotify.enable pkgs.spotify
      ++ lib.optional cfg.gimp.enable pkgs.gimp
      ++ lib.optional cfg.imv.enable pkgs.imv;
  };
}

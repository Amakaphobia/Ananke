{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.media.vlc;
in
{
  options.ananke.desktop.media.vlc = {
    enable = lib.mkEnableOption "vlc-player";
  };

  config = lib.mkIf (config.ananke.desktop.media.enable && cfg.enable) {
    home.packages = pkgs.vlc;
  };

}

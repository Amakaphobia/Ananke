{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.media.vlc;
in
{
  options.ananke.home.desktop.media.vlc = {
    enable = lib.mkEnableOption "vlc-player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vlc ];
  };

}

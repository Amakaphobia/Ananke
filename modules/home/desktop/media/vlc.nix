{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.media.vlc;
in
{
  options.ananke.profiles.home.desktop.media.vlc = {
    enable = lib.mkEnableOption "vlc-player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vlc ];
  };

}

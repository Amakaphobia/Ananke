{ config, lib, ... }:
let
  cfg = config.ananke.profiles.desktop.media;
in
{
  options.ananke.profiles.desktop.media = {
    enable = lib.mkEnableOption "media";
  };

  config = lib.mkIf cfg.enable {
    config.ananke.desktop.media = {
      vlc.enable = lib.mkDefault true;
      spicetify.enable = lib.mkDefault true;
    };
  };
}

{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.media;
in
{
  imports = [
    (paths.modules + "/home/desktop/media")
  ];

  options.ananke.profiles.home.desktop.media = {
    enable = lib.mkEnableOption "media";
  };

  config = lib.mkIf cfg.enable {
    ananke.home.desktop.media = {
      vlc.enable = lib.mkDefault true;
      spicetify.enable = lib.mkDefault true;
    };
  };
}

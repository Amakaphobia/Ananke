{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.office.libreoffice;
in
{
  options.ananke.profiles.home.desktop.office.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice
    ];
  };
}

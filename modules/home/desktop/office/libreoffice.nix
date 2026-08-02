{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.libreoffice;
in
{
  options.ananke.home.desktop.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice
    ];
  };
}

{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.office;
in
{
  imports = [
    (paths.modules + "/home/desktop/office")
  ];

  options.ananke.profiles.home.desktop.office = {
    enable = lib.mkEnableOption "office tools";
  };

  config = lib.mkIf cfg.enable {
    ananke.home.desktop = {
      libreoffice.enable = lib.mkDefault true;
      thunderbird = {
        enable = lib.mkDefault true;
        default.enable = lib.mkDefault true;
      };
    };
  };
}

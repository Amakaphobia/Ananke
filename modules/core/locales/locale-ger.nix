{ config, lib, ... }:
let
  cfg = config.ananke.system.core.locale.ger;
in
{
  options.ananke.system.core.locale.ger = {
    enable = lib.mkEnableOption "Sensible german locale overrides";
  };

  config = lib.mkIf cfg.enable {
    ananke.system.core.locale = {
      time.timeZone = "Europe/Berlin";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
      };

      console.keyMap = "de";
    };
  };
}

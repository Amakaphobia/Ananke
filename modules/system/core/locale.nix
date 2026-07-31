{ config, lib, ... }:
let
  cfg = config.ananke.system.core.locale;
  helper = import ../../home/lib/helper.nix { inherit lib; };
in
{
  options.ananke.system.core.locale = {
    enable = lib.mkEnableOption "locale";

    time.timeZone = helper.mkStringFallbackOption "Europe/Berlin" "your timezone";

    # internationalization settings
    i18n.defaultLocale = helper.mkStringFallbackOption "en_US.UTF-8" "use english UTF-8 unless a categorie is overwritten";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = helper.mkStringFallbackOption "en_US.UTF-8" "Adresses";
      LC_IDENTIFICATION = helper.mkStringFallbackOption "en_US.UTF-8" "Metadata format when programs request the active locale";
      LC_MEASUREMENT = helper.mkStringFallbackOption "en_US.UTF-8" "Meassurements";
      LC_MONETARY = helper.mkStringFallbackOption "en_US.UTF-8" "Money";
      LC_NAME = helper.mkStringFallbackOption "en_US.UTF-8" "personal names";
      LC_NUMERIC = helper.mkStringFallbackOption "en_US.UTF-8" "number formats";
      LC_PAPER = helper.mkStringFallbackOption "en_US.UTF-8" "paper format";
      LC_TELEPHONE = helper.mkStringFallbackOption "en_US.UTF-8" "telephone numbers";
      LC_TIME = helper.mkStringFallbackOption "en_US.UTF-8" "Date and Time Formats";
    };

    console.keyMap = helper.mkStringFallbackOption "en" "keymap layout in virtual consoles";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.time.timeZone;

    i18n = {
      defaultLocale = cfg.i18n.defaultLocale;
      extraLocaleSettings = cfg.i18n.extraLocaleSettings;
    };

    console.keyMap = cfg.console.keyMap;
  };

}

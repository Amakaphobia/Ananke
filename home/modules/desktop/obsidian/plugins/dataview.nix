{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.obsidian;
  dataview = pkgs.stdenvNoCC.mkDerivation rec {

    pname = "obsidian-dataview";
    version = "0.5.68";

    manifest = pkgs.fetchurl {
      url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/manifest.json";
      hash = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
    };

    mainJs = pkgs.fetchurl {
      url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/main.js";
      hash = "sha256-eU6ert5zkgu41UsO2k9d4hgtaYzGOHdFAPJPFLzU2gs=";
    };

    stylesCss = pkgs.fetchurl {
      url = "https://github.com/blacksmithgu/obsidian-dataview/releases/download/${version}/styles.css";
      hash = "sha256-MwbdkDLgD5ibpyM6N/0lW8TT9DQM7mYXYulS8/aqHek=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out

      cp ${manifest} $out/manifest.json
      cp ${mainJs} $out/main.js
      cp ${stylesCss} $out/styles.css
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian.defaultSettings.communityPlugins = [
      {
        pkg = dataview;
      }
    ];
  };
}

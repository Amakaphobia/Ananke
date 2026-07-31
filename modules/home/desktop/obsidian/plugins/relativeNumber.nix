{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.obsidian;

  relativeLineNumbers = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "obsidian-relative-line-numbers";
    version = "3.1.0";

    mainJs = pkgs.fetchurl {
      url = "https://github.com/nadavspi/${pname}/releases/download/${version}/main.js";
      hash = "sha256-JpufX+6TrczDl9MZmRgYrZThsC/tUT2pusVP9e7ln6U=";
    };

    manifest = pkgs.fetchurl {
      url = "https://github.com/nadavspi/${pname}/releases/download/${version}/manifest.json";
      hash = "sha256-6ZhpsAukiZT17B+oYosLs/10+euPerkmz1pIEMvKHGs=";
    };

    styles = pkgs.fetchurl {
      url = "https://github.com/nadavspi/${pname}/releases/download/${version}/styles.css";
      hash = "sha256-cFvcj1jC6GluwtmcQ2k42hVPQvVXkIquVLXM4PDjXAI=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp ${mainJs} $out/main.js
      cp ${manifest} $out/manifest.json
      cp ${styles} $out/styles.css

      runHook postInstall
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian.defaultSettings.communityPlugins = [
      {
        pkg = relativeLineNumbers;
      }
    ];
  };
}

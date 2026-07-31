{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.obsidian;

  styleSettings = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "obsidian-style-settings";
    version = "1.0.9";

    manifest = pkgs.fetchurl {
      url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/manifest.json";
      hash = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g=";
    };

    mainJs = pkgs.fetchurl {
      url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/main.js";
      hash = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
    };

    styleCss = pkgs.fetchurl {
      url = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${version}/styles.css";
      hash = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out
      cp ${manifest} $out/manifest.json
      cp ${mainJs} $out/main.js
      cp ${styleCss} $out/styles.css
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian.defaultSettings.communityPlugins = [
      {
        pkg = styleSettings;
        settings = builtins.fromJSON (builtins.readFile ./data.json);
      }
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  anuPpuccinObsidian = pkgs.stdenvNoCC.mkDerivation {
    pname = "anuPpuccinObsidian";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "AnubisNekhet";
      repo = "AnuPpuccin";
      rev = "93edd678ee5f2e090479f1807dfe13c71fc22720";
      hash = "sha256-T66bh2dTk15HbCKaruMOYPbExO150mrPfAQeNVz56bs=";
    };

    nativeBuildInputs = [ pkgs.dart-sass ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp manifest.json theme.css $out/
      runHook postInstall
    '';
  };

  cfg = config.ananke.desktop.obsidian;
in
{
  config = lib.mkIf cfg.enable {
    programs.obsidian.vaults.main.settings.themes = [
      anuPpuccinObsidian
    ];
  };
}

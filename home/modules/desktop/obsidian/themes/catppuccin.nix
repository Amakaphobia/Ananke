{ pkgs, ... }:
let
  catppuccinObsidian = pkgs.stdenvNoCC.mkDerivation {
    pname = "myCatppuccin";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "obsidian";
      rev = "1e7aabc47addeefe79dd0362c9976dfa3367c1f9";
      hash = "sha256-9fSFj9Tzc2aN9zpG5CyDMngVcwYEppf7MF1ZPUWFyz4=";
    };

    installPhase = ''
      mkdir -p $out
      cp manifest.json theme.css $out/
    '';
  };
in
{
  programs.obsidian.vaults.main.settings.themes = [
    catppuccinObsidian
  ];
}

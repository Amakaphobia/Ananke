{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.media.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  options.ananke.home.desktop.media.spicetify = {
    enable = lib.mkEnableOption "spicetify";
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        shuffle
        fullAppDisplay
        keyboardShortcut
        trashbin
      ];
    };
  };
}

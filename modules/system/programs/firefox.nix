{
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.system.programs.firefox;
in
{
  options.ananke.system.programs.firefox = {
    enable = lib.mkEnableOption "Install Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        HardwareAcceleration = true;
        SearchEngines.Default = "DuckDuckGo";
        AIControls.Default = {
          Value = "blocked";
          Locked = true;
        };
      };
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;

        # Fonts
        # make sure websites may use the fontsthey prefer
        "browser.display.use_document_fonts" = 1;

        # Primary Firefox fonts are set by stylix

        # Fallback chains are set by fontconfig

        # Used by some content that Firefox classifies as general Unicode
        "font.name-list.sans-serif.x-unicode" = "Noto Sans, Symbols Nerd Font";
        "font.name-list.serif.x-unicode" = "Noto Serif, Symbols Nerd Font";
        "font.name-list.monospace.x-unicode" = "JetBrainsMono Nerd Font Mono, Symbols Nerd Font Mono";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.desktop.screenshot;
in
{
  options.ananke.home.desktop.screenshot = {
    enable = lib.mkEnableOption "Screenshot tooling";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # screenshot
      grim
      # geometry selection
      slurp
      # annotations
      satty
      # clipboard
      wl-clipboard
    ];
  };
}

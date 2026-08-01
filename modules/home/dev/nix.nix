{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.dev.nix;
in
{
  options.ananke.home.dev.nix = {
    enable = lib.mkEnableOption "nix tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      statix
      deadnix
    ];
  };
}

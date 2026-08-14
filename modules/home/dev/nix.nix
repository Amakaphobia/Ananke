{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.profiles.home.dev.nix;
in
{
  options.ananke.profiles.home.dev.nix = {
    enable = lib.mkEnableOption "nix tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      statix
      deadnix
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.ananke.dev.nix;
in
{
  options.ananke.modules.dev.nix = {
    enable = lib.mkEnableOption "nix tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      statix
      deadnix
    ];
  };
}

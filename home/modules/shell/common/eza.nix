{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons;
  helper = import ../../../lib/helper.nix { inherit lib; };
in
{
  options.ananke.shell.addons.eza = {
    enable = helper.mkDefaultOnOption "eza";
    enableZshIntegration = lib.mkEnableOption "automatic aliases for eza";
  };

  config = lib.mkIf (cfg.enable && cfg.eza.enable) {
    programs.eza = {

      enable = true;
    };

  };
}

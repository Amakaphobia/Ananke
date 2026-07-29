{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons;
  helper = import ../../../lib/helper.nix;
in
{
  options.ananke.cli.eza = {
    enable = helper.mkDefaultOnOption "eza";
  };

  config = lib.mkIf (cfg.enable && cfg.eza.enable) {
    programs.eza = {

      enable = true;
    };
  };

}

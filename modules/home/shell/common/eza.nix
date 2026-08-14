{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.shell.addons;
  helper = import (paths.lib + "/helper.nix") { inherit lib; };
in
{
  options.ananke.profiles.home.shell.addons.eza = {
    enable = helper.mkDefaultOnOption "eza";
  };

  config = lib.mkIf (cfg.enable && cfg.eza.enable) {
    programs.eza = {
      enable = true;
    };

  };
}

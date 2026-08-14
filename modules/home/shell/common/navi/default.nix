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
  options.ananke.profiles.home.shell.addons.navi = {
    enable = helper.mkDefaultOnOption "navi";
  };
  config = lib.mkIf (cfg.enable && cfg.navi.enable) {

    programs.navi = {
      enable = true;
    };

    xdg.dataFile."navi/cheats/ananke" = {
      source = ./cheats;
      recursive = true;
    };
  };
}

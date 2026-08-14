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
  options.ananke.profiles.home.shell.addons.fzf = {
    enable = helper.mkDefaultOnOption "fzf";
  };
  config = lib.mkIf (cfg.enable && cfg.fzf.enable) {

    programs.fzf = {
      enable = true;
    };
  };
}

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
  options.ananke.profiles.home.shell.addons.zoxide = {
    enable = helper.mkDefaultOnOption "zoxide";
  };
  config = lib.mkIf (cfg.enable && cfg.zoxide.enable) {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

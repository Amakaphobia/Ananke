{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons.zoxide;
  helper = import ../../../lib/helper.nix { inherit lib; };
in
{
  options.ananke.shell.addons.zoxide = {
    enable = helper.mkDefaultOnOption "zoxide";
  };
  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

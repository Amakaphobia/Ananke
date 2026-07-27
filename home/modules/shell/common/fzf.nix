{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons.fzf;
  helper = import ../../../lib/helper.nix { inherit lib; };
in
{
  options.ananke.shell.addons.fzf = {
    enable = helper.mkDefaultOnOption "fzf";
  };
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };
  };
}

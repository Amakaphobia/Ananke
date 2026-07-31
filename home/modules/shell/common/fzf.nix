{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.ananke.shell.addons;
  helper = import "${self}/lib/helper.nix" { inherit lib; };
in
{
  options.ananke.shell.addons.fzf = {
    enable = helper.mkDefaultOnOption "fzf";
  };
  config = lib.mkIf (cfg.enable && cfg.fzf.enable) {

    programs.fzf = {
      enable = true;
    };
  };
}

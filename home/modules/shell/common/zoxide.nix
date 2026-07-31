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
  options.ananke.shell.addons.zoxide = {
    enable = helper.mkDefaultOnOption "zoxide";
  };
  config = lib.mkIf (cfg.enable && cfg.zoxide.enable) {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

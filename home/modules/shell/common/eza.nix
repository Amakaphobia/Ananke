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
  options.ananke.shell.addons.eza = {
    enable = helper.mkDefaultOnOption "eza";
  };

  config = lib.mkIf (cfg.enable && cfg.eza.enable) {
    programs.eza = {
      enable = true;
    };

  };
}

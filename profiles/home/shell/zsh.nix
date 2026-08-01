{
  config,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.profiles.home.shell.zsh;
in
{
  imports = [ (paths.modules + "/home/shell") ];

  options.ananke.profiles.home.shell.zsh = {
    enable = lib.mkEnableOption "zsh profile";
  };
  config = lib.mkIf cfg.enable {
    ananke.home.shell = {
      zsh.enable = lib.mkDefault true;
      addons.enable = lib.mkDefault true;
    };
  };
}

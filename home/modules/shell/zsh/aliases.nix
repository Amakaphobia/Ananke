{ config, lib, ... }:
let
  cfg = config.ananke.profiles.shell.zsh.dave.aliases;
in
{
  options.ananke.profiles.shell.zsh.dave.aliases.enable = lib.mkEnableOption "Dave's aliases";

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      sr = "systemctl reboot";
      sd = "systemctl poweroff";
      hh = "systemctl hibernate";
      chelp = "cat ~/color-info.txt";
    };

    # eza configures this now
    programs.zsh.shellAliases = lib.mkIf (!config.ananke.shell.addons.eza.enable) {
      ll = "ls -lisa";
  };
}

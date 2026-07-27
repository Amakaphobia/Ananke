{ config, lib, ... }:
let
  cfg = config.ananke.profiles.shell.zsh.dave.aliases;
in
{
  options.ananke.profiles.shell.zsh.dave.aliases.enable = lib.mkEnableOption "Dave's aliases";

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      ll = "ls -lisa";
      sr = "systemctl reboot";
      sd = "systemctl poweroff";
      hh = "systemctl hibernate";
      chelp = "cat ~/color-info.txt";
    };
  };
}

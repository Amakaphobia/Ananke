{ config, lib, ... }:
let
  cfg = config.ananke.profiles.shell.zsh.dave.aliases;
  addons = config.ananke.shell.addons;
  ezaEnabled = (addons.enable && addons.eza.enable);
in
{
  options.ananke.profiles.shell.zsh.dave.aliases.enable = lib.mkEnableOption "Dave's aliases";

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      sr = "systemctl reboot";
      sd = "systemctl poweroff";
      hh = "systemctl hibernate";
      chelp = "cat ~/color-info.txt";
    }

    #handle shell aliases for eza or no eza
    // lib.optionalAttrs (!ezaEnabled) {
      ll = "ls -lisa";
    }
    // lib.optionalAttrs ezaEnabled {
      ls = "eza --icons=auto --color=auto --group-directories-first";

      ll = "eza --long --header --icons=auto --color=auto --git --group-directories-first";

      la = "eza --all --icons=auto --color=auto --group-directories-first";

      lla = "eza --long --all --header --icons=auto --color=auto --git --group-directories-first";

      lt = "eza --tree --level=2 --icons=auto --color=auto --group-directories-first";
    };

  };
}

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
      # short list
      ls = "eza --icons=auto --color=auto --group-directories-first";
      # long list
      ll = "eza --long --header --icons=auto --color=auto --git --group-directories-first";
      # short list show hidden files
      la = "eza --all --icons=auto --color=auto --group-directories-first";
      # long list show hidden files
      lla = "eza --long --all --header --icons=auto --color=auto --git --group-directories-first";
      # short tree
      lt = "eza --tree --level=2 --icons=auto --color=auto --group-directories-first";
      # long tree show hidden files ignore .git and common build directories
      lta = "eza --tree --all --level=9 --icons=auto --color=auto --group-directories-first --ignore-glob='.git|.direnv|result|node_modules'";

      # project tree without Git-ignored files
      ltg = "eza --tree --all --level=4 --git-ignore --icons=auto --color=auto --group-directories-first";
      # newest entries first, with readable relative timestamps
      lnew = "eza --long --all --header --sort=newest --time-style=relative --icons=auto --color=auto --group-directories-first";
    };

  };
}

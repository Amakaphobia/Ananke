{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons;
  helper = import ../../../lib/helper.nix { inherit lib; };
in
{
  options.ananke.shell.addons.eza = {
    enable = helper.mkDefaultOnOption "eza";
    enableZshIntegration = lib.mkEnableOption "automatic aliases for eza";
  };

  config = lib.mkIf (cfg.enable && cfg.eza.enable) {
    programs.eza = {

      enable = true;
    };

    programs.zsh.shellAliases = lib.mkIf (!cfg.eza.enableZshIntegration) {
      ls = "eza --icons=auto --color=auto --group-directories-first";

      ll = "eza --long --header --icons=auto --color=auto --git --group-directories-first";

      la = "eza --all --icons=auto --color=auto --group-directories-first";

      lla = "eza --long --all --header --icons=auto --color=auto --git --group-directories-first";

      lt = "eza --tree --level=2 --icons=auto --color=auto --group-directories-first";
    };
  };
}

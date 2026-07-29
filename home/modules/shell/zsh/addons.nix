{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons;
in
{
  imports = [
    ../common
  ];

  options.ananke.shell.addons = {
    enable = lib.mkEnableOption "zsh addons";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      #eza
      eza.enableZshIntegration = cfg.enable && cfg.eza.enable;
      # FZF
      fzf.enableZshIntegration = cfg.enable && cfg.fzf.enable;
      # starship
      starship.enableZshIntegration = cfg.enable && cfg.starship.enable;
      # zoxide
      zoxide.enableZshIntegration = cfg.enable && cfg.zoxide.enable;
    };
  };
}

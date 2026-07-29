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
      eza.enableZshIntegration = cfg.eza.enable;
      # FZF
      fzf.enableZshIntegration = cfg.fzf.enable;
      # starship
      starship.enableZshIntegration = cfg.starship.enable;
      # zoxide
      zoxide.enableZshIntegration = cfg.zoxide.enable;
    };
  };
}

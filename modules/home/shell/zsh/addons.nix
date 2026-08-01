{ config, lib, ... }:
let
  cfg = config.ananke.home.shell.addons;
in
{
  imports = [
    ../common
  ];

  options.ananke.home.shell.addons = {
    enable = lib.mkEnableOption "shell addons";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      # eza
      eza.enableZshIntegration = lib.mkDefault cfg.eza.enable;
      # FZF
      fzf.enableZshIntegration = lib.mkDefault cfg.fzf.enable;
      # starship
      starship.enableZshIntegration = lib.mkDefault cfg.starship.enable;
      # zoxide
      zoxide.enableZshIntegration = lib.mkDefault cfg.zoxide.enable;
    };
  };
}

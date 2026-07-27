{ config, lib, ... }:
let
  cfg = config.ananke.shell.addons;
in
{
  imports = [
    ../common/starship.nix
    ../common/zoxide.nix
    ../common/fzf.nix
  ];

  options.ananke.shell.addons = {
    enable = lib.mkEnableOption "zsh addons";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      # FZF
      fzf.enableZshIntegration = cfg.fzf.enable;
      # starship
      starship.enableZshIntegration = cfg.starship.enable;
      # zoxide
      zoxide.enableZshIntegration = cfg.zoxide.enable;
    };
  };
}

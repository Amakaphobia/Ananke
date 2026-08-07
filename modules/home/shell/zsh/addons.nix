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
      # make zsh command duration and exit status available to starship
      zsh.initContent = lib.mkIf cfg.starship.enable (
        lib.mkAfter ''
          autoload -Uz add-zsh-hook

          _ananke_starship_export_command_info() {
            if [[ -v STARSHIP_CMD_STATUS && -v STARSHIP_DURATION ]]; then
              export ANANKE_CMD_STATUS="$STARSHIP_CMD_STATUS"
              export ANANKE_CMD_DURATION="$STARSHIP_DURATION"
            else
              unset ANANKE_CMD_STATUS ANANKE_CMD_DURATION
            fi
          }

          add-zsh-hook precmd _ananke_starship_export_command_info
        ''
      );
      # zoxide
      zoxide.enableZshIntegration = lib.mkDefault cfg.zoxide.enable;
    };
  };
}

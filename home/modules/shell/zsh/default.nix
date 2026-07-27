{ config, lib, ... }:
let
  cfg = config.ananke.shell.zsh;
in
{

  imports = [
    ./addons.nix
    ./aliases.nix
  ];
  options.ananke.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      # sane defaults
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        size = 10000;
        save = 10000;
        path = "$HOME/.zsh_history";
      };
    };
  };
}

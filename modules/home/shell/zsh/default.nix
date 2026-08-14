{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.shell.zsh;
in
{

  imports = [
    ./addons.nix
  ];

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
        ignoreSpace = true;
      };
      initContent = lib.mkAfter ''
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^X^E' edit-command-line
      '';
    };
  };
}

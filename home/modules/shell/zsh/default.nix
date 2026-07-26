{ ... }:

{

  imports = [ ./addons.nix ];
  # Zsh
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
    };
    shellAliases = {
      ll = "ls -lisa";
      sr = "systemctl reboot";
      sd = "systemctl poweroff";
      hh = "systemctl hibernate";
      chelp = "cat ~/color-info.txt";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.cli.tmux;

  colors = config.ananke.theme.scheme.roles;
  hex = color: "#${color}";

  sessionizerPackage = pkgs.writeShellApplication {
    name = "tmux-sessionizer";
    runtimeInputs = with pkgs; [
      fd
      fzf
      git
      tmux
      coreutils
    ];
    text = builtins.readFile ./sessionizer.sh;
  };
in
{
  options.ananke.home.cli.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      sessionizerPackage
    ];
    programs.tmux = {
      enable = true;

      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-a";
      baseIndex = 1;

      extraConfig = ''
        set -g @window_bg "${hex colors.info}"
        set -g @right_bg "${hex colors.accent}"
        set -g @status_fg "${hex colors.surface}"
        set -g @border_grey "${hex colors.overlay}"

        ${builtins.readFile ./tmux.conf}
      '';
    };
  };
}

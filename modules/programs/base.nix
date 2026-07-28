{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.system.base;
in
{

  options.ananke.system.base = {
    enable = lib.mkEnableOption "System base";
  };

  # installing system level packages
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [

      wget
      curl
      unzip
      zip
      tree
      ripgrep
      gnutar
      bat
      procps
      killall

      nodejs
      jdk
      python3
      gcc
      gnumake
      fzf
      lua51Packages.luarocks
      lua5_1
      fastfetch

      # general purpose library with datastructure, process, file/path, desktop utilities
      glib

      openssh
      libva-utils
    ];

    programs = {
      # Allows for homemamager to set gtk settings
      dconf.enable = true;
      # enable the cool shell
      zsh.enable = true;

      # make /share/zsh available
      environment.pathsToLink = [ "/share/zsh" ];

    };
  };
}

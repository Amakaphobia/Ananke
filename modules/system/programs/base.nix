{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.profiles.system.programs.base;

in
{

  options.ananke.profiles.system.programs.base = {
    enable = lib.mkEnableOption "System base";
  };

  # installing system level packages
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [

      wget
      curl
      unzip
      zip
      ripgrep
      gnutar
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

    };
    # make /share/zsh available
    environment.pathsToLink = [ "/share/zsh" ];
  };
}

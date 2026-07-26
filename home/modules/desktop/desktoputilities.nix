{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.desktop.utilities;
in
{

  options.ananke.desktop.utilities = {
    enable = lib.mkEnableOption "Enable desktop utils";
    geany.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Geany a gui editor";
    };
    pastel.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Pastel, a terminal color utility.";
    };
    wl-clipboard.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Instal wl-clipboard, a blipboard utility";
    };
    brightnessctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install brightnessctl, a basic utility.";
    };
    playerctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install playerctl, a basic audio utility.";
    };
    vlc.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install vlc, a basic media player";
    };
    spotify.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install spotify a music player";
    };
    gimp.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Gimp. The Gnu Image Manipulation Program";
    };
    imv.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install imv. A simple image viewer";
    };
    libnotify.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Libnotify, so notifications can be send";
    };
    pavucontrol.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install pavucontrol, a graphical sound control";
    };
    networkmanagerapplet.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install networkmanagerapplet, a graphical network interface control";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.geany.enable pkgs.geany
      ++ lib.optional cfg.pastel.enable pkgs.pastel
      ++ lib.optional cfg.wl-clipboard.enable pkgs.wl-clipboard
      ++ lib.optional cfg.brightnessctl.enable pkgs.brightnessctl
      ++ lib.optional cfg.playerctl.enable pkgs.playerctl
      ++ lib.optional cfg.vlc.enable pkgs.vlc
      ++ lib.optional cfg.spotify.enable pkgs.spotify
      ++ lib.optional cfg.gimp.enable pkgs.gimp
      ++ lib.optional cfg.imv.enable pkgs.imv
      ++ lib.optional cfg.libnotify.enable pkgs.libnotify
      ++ lib.optional cfg.pavucontrol.enable pkgs.pavucontrol
      ++ lib.optional cfg.networkmanagerapplet.enable pkgs.networkmanagerapplet;
  };
}

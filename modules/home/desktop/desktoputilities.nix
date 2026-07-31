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
    enable = lib.mkEnableOption "Desktop Utilities";
    wl-clipboard.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Wl-clipboard";
    };
    brightnessctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Brightnessctl";
    };
    playerctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Playerctl";
    };
    libnotify.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Libnotify";
    };
    pavucontrol.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Pavucontrol";
    };
    networkmanagerapplet.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install Networkmanagerapplet";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optional cfg.wl-clipboard.enable pkgs.wl-clipboard
      ++ lib.optional cfg.brightnessctl.enable pkgs.brightnessctl
      ++ lib.optional cfg.playerctl.enable pkgs.playerctl
      ++ lib.optional cfg.libnotify.enable pkgs.libnotify
      ++ lib.optional cfg.pavucontrol.enable pkgs.pavucontrol
      ++ lib.optional cfg.networkmanagerapplet.enable pkgs.networkmanagerapplet;
  };
}

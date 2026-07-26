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
    enable = lib.mkEnableOption "Desktop utilities";
    wl-clipboard.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "wl-clipboard";
    };
    brightnessctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "brightnessctl";
    };
    playerctl.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "playerctl";
    };
    libnotify.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Libnotify";
    };
    pavucontrol.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "pavucontrol";
    };
    networkmanagerapplet.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "networkmanagerapplet";
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

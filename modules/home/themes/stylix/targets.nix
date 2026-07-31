{ ... }:
{

  config.stylix = {
    targets = {
      # allow fonts to be configured
      font-packages.enable = true;
      fontconfig.enable = true;

      # gtk
      gtk.enable = true;

      # qt
      qt.enable = true;

      # notifs
      swaync.enable = true;

      # btop
      btop.enable = false;

      # menu
      fuzzel.enable = true;

      # firefox
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
      # kitty - keep colors on manual
      kitty = {
        enable = true;
        colors.enable = false;
      };
    };
    opacity = {
      terminal = 0.8;
      popups = 0.8;
    };
  };
}

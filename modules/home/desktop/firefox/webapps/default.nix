{ lib, ... }:
{
  imports = [
    ./excalidraw.nix
  ];

  options.ananke.profiles.home.desktop.firefox.webapps = {
    enable = lib.mkEnableOption "Webapps";
  };
}

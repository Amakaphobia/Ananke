{
  config,
  pkgs,
  inputs,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.desktop.waybar;
  theme = config.ananke.modules.theme.scheme;

  fonts = import (paths.lib + "/fontCatalog.nix") { inherit pkgs; };
  clockFont = fonts.mapleMono.package;

  colorsLib = import (paths.lib + "/colors.nix") {
    inherit lib;
  };

  colorCss = colorsLib.toGtkCss theme.roles;
  waybarConfig = pkgs.runCommand "waybar-config-${theme.name}" { } ''
    mkdir -p "$out"

    cp -R ${./config}/. "$out/"
    chmod -R u+w "$out"

    printf '%s\n' ${lib.escapeShellArg colorCss} > "$out/style/color.css"
  '';
in
{
  options.ananke.desktop.waybar = {
    enable = lib.mkEnableOption "Waybar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # ensure theme fonts are installed:
      clockFont
    ];
    programs.waybar = {
      enable = true;
      # autostart:
      systemd.enable = true;
      package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    xdg.configFile."waybar".source = waybarConfig;
  };
}

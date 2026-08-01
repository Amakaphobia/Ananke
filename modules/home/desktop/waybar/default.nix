{
  config,
  pkgs,
  inputs,
  lib,
  paths,
  ...
}:
let
  cfg = config.ananke.home.desktop.waybar;
  theme = config.ananke.theme.scheme;

  fonts = import (paths.lib + "/fontCatalog.nix") { inherit pkgs; };
  clockFont = fonts.mapleMono.package;

  colorsLib = import (paths.lib + "/colors.nix") {
    inherit lib;
  };

  colorCss = colorsLib.toGtkCss theme.roles;

  # make sh available during build
  waybarPackage =
    inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (oldAttrs: {
        nativeCheckInputs = (oldAttrs.nativeCheckInputs or [ ]) ++ [ pkgs.bash ];
      });

  waybarConfig = pkgs.runCommand "waybar-config-${theme.name}" { } ''
    mkdir -p "$out"

    cp -R ${./config}/. "$out/"
    chmod -R u+w "$out"

    printf '%s\n' ${lib.escapeShellArg colorCss} > "$out/style/color.css"
  '';
in
{
  options.ananke.home.desktop.waybar = {
    enable = lib.mkEnableOption "Waybar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # ensure theme fonts are installed:
      clockFont
    ];
    programs.waybar = {
      enable = true;
      package = waybarPackage;
      # autostart:
      systemd.enable = true;
    };

    xdg.configFile."waybar".source = waybarConfig;
  };
}

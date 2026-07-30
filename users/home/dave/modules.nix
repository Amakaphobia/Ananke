{ ... }:
{

  imports = [
    # custom Scripts
    ../../../home/scripts

    # base shell profile
    ../../../profiles/home/shell/zsh.nix
    # cli default profile profile
    ../../../profiles/home/cli
    # hyprland desktop profile
    ../../../profiles/home/desktop/hypr.nix
  ];

  config.ananke = {
    profiles = {
      shell.zsh = {
        enable = true;
        dave.aliases.enable = true;
      };
      cli.base.enable = true;
      desktop.hypr.enable = true;
    };

    desktop = {
      obsidian.enable = true;

      firefox.webapps.excalidraw.enable = true;

      apps = {
        enable = true;

        geany.enable = true;
        gimp.enable = true;
        imv.enable = true;
        vlc.enable = true;
        spotify.enable = true;
      };

      hypr.commands = {
        menu = "fuzzel-once";
        hyprLayoutToggle = "hyprland-toggle-layout";
        barToggle = "waybar-toggle";
        lockScreen = "hyprlock-once";
        screenshotRegion = "screenshot-region";
        screenshotComplete = "screenshot-complete";
      };
    };
  };
}

{ paths, ... }:
{

  imports = [
    # base shell profile
    (paths.profiles + "/home/shell/zsh.nix")
    # cli default profile profile
    (paths.profiles + "/home/cli")
    # hyprland desktop profile
    (paths.profiles + "/home/desktop/hypr.nix")
    # dev profile
    (paths.profiles + "/home/dev")
  ];

  config.ananke = {
    profiles = {
      home = {
        shell.zsh = {
          enable = true;
          dave.aliases.enable = true;
        };
        cli.base.enable = true;
        desktop.hypr.enable = true;
        dev.enable = true;
      };

    };

    home = {
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
  };
}

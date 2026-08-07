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
    # media players
    (paths.profiles + "/home/desktop/media.nix")
    # office tools
    (paths.profiles + "/home/desktop/office.nix")
  ];

  config.ananke = {
    profiles = {
      home = {
        shell.zsh = {
          enable = true;
          akio.aliases.enable = true;
        };
        cli = {
          base.enable = true;
          ssh.akio.enable = true;
        };
        dev.enable = true;
        desktop = {
          hypr.enable = true;
          media.enable = true;
          office.enable = true;
        };
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
        };

        hypr.commands = {
          menu = "fuzzel-once";
          hyprLayoutToggle = "hyprland-toggle-layout";
          barToggle = "waybar-toggle";
          lockScreen = "hyprlock-once";
          screenshotRegion = "screenshot-region";
          screenshotComplete = "screenshot-complete";
          hyprSunsetToggle = "hyprsunset-toggle";
        };
      };
    };
  };
}

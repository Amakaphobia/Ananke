{ homeModulesPath, ... }:
{

  imports = [
    # process homeMonitor
    (homeModulesPath + "/btop.nix")
    # git
    (homeModulesPath + "/git.nix")
    # editor
    (homeModulesPath + "/nixvim")
    # stuff
    (homeModulesPath + "/packages.nix")
    # ssh
    (homeModulesPath + "/ssh.nix")
    # custom Scripts
    ../../scripts
    # shell configuration
    (homeModulesPath + "/shell")

    # hyprland desktop profile
    ../../profiles/desktop/hypr.nix
  ];

  config.ananke = {
    desktop = {
      profiles = {
        hypr.enable = true;
      };

      obsidian.enable = true;

      apps = {
        enable = true;

        geany.enable = true;
        pastel.enable = true;
        gimp.enable = true;
        imv.enable = true;
        vlc.enable = true;
        spotify.enable = true;
      };

      hypr.commands = {
        menu = "fuzzel-once";
        hyprLayoutToggle = "hyprland-toggle-layout";
        barToggle = "toggle-waybar";
        lockScreen = "hyprlock-once";
        screenshotRegion = "screenshot-region";
        screenshotComplete = "screenshot-complete";
      };
    };
  };
}

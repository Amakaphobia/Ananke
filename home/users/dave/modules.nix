{ homeModulesPath, ... }:
{

  imports = [
    # process homeMonitor
    (homeModulesPath + "/btop.nix")
    # git
    (homeModulesPath + "/git.nix")
    # editor
    (homeModulesPath + "/nixvim")
    # knowledge
    (homeModulesPath + "/obsidian")
    # stuff
    (homeModulesPath + "/packages.nix")
    # ssh
    (homeModulesPath + "/ssh.nix")
    # custom Scripts
    ../../scripts
    # statusbar
    (homeModulesPath + "/waybar")
    # how sandboxed/wayland apps ask for desktop features
    (homeModulesPath + "/xdg.nix")
    # shell configuration
    (homeModulesPath + "/shell")

    # hyprland desktop profile
    ../../profiles/desktop/hypr.nix
  ];

  config.ananke = {
    desktop = {
      profiles.hypr = {
        enable = true;
      };
      hypr.commands = {
        menu = "fuzzel-once";
        hyprLayoutToggle = "hypr-toggle-layout";
        barToggle = "toggle-waybar";
        lockscreen = "hyprlock-once";
        screenshotRegion = "screenshot-region";
        screenshotComplete = "screenshot-Complete";
      };
    };
  };
}

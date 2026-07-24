{ homeModulesPath, ... }:
{

  imports = [
    # process homeMonitor
    (homeModulesPath + "/btop.nix")
    # firefox user profiles
    (homeModulesPath + "/firefox.nix")
    # fuzzel
    (homeModulesPath + "/fuzzel.nix")
    # git
    (homeModulesPath + "/git.nix")
    # hypr
    (homeModulesPath + "/hypr")
    # terminal
    (homeModulesPath + "/kitty.nix")
    # editor
    (homeModulesPath + "/nixvim")
    # knowledge
    (homeModulesPath + "/obsidian")
    # stuff
    (homeModulesPath + "/packages.nix")
    # polkit
    (homeModulesPath + "/polkit.nix")
    # screenshots
    (homeModulesPath + "/screenshot.nix")
    # ssh
    (homeModulesPath + "/ssh.nix")
    # custom Scripts
    ../../scripts
    # sway notification center
    (homeModulesPath + "/swaync.nix")
    # thunar settings
    (homeModulesPath + "/thunar.nix")
    # statusbar
    (homeModulesPath + "/waybar")
    # how sandboxed/wayland apps ask for desktop features
    (homeModulesPath + "/xdg.nix")
    # shell configuration
    (homeModulesPath + "/shell")
  ];
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # gui editor
    geany
    # a jason processor
    jq
    # nix language server
    nil
    # nix formatter
    nixfmt
    # terminal git
    lazygit
    # find ...
    fd
    # funny man
    tldr
    # clipboard
    wl-clipboard
    # show color
    pastel
    # brightness key
    brightnessctl
    # volume key
    playerctl
    # music + video
    spotify
    vlc
    # pictures
    gimp
    imv
    # enables to send desktop notifications
    libnotify
    # graphical sound control
    pavucontrol
    # graphical network control
    networkmanagerapplet
  ];

}

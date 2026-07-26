{ pkgs, ... }:
{
  # installing system level packages
  environment.systemPackages = with pkgs; [

    wget
    curl
    unzip
    zip
    tree
    ripgrep
    gnutar
    bat
    procps
    killall

    nodejs
    jdk
    python3
    gcc
    gnumake
    fzf
    lua51Packages.luarocks
    lua5_1
    fastfetch

    openssh
    libva-utils
  ];

  programs = {
    # Allows for homemamager to set gtk settings
    dconf.enable = true;
    # enable the cool shell
    zsh.enable = true;
  };

  # make /share/zsh available
  environment.pathsToLink = [ "/share/zsh" ];

}

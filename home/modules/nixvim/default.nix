{ pkgs, ... }:

{

  imports = [
    ./options.nix
    ./keymaps.nix
    ./addons
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Use the Nix-generated configuration and ignore ~/.config/nvim.
    wrapRc = true;
    impureRtp = false;

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    extraPackages = with pkgs; [
      # Search and navigation
      ripgrep
      fd
    ];
  };
}

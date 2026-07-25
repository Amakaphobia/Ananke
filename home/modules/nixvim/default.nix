{ pkgs, ... }:

{

  imports = [
    ./theme/catppuccin.nix
    ./options.nix
    ./keymaps.nix
    ./addons
    ./autocmds.nix
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

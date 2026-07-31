{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.cli.nixvim;
in
{
  imports = [
    ./theme/catppuccin.nix
    ./options.nix
    ./keymaps.nix
    ./addons
    ./autocmds.nix
  ];

  options.ananke.cli.nixvim = {
    enable = lib.mkEnableOption "Nixvim";
  };

  config = lib.mkIf cfg.enable {
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

  };
}

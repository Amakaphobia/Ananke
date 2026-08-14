{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.ananke.profiles.home.cli.nixvim;
in
{
  imports = [
    ./addons
    ./autocmds.nix
    ./diagnostics.nix
    ./keymaps.nix
    ./options.nix
    ./theme/catppuccin.nix
  ];

  options.ananke.profiles.home.cli.nixvim = {
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

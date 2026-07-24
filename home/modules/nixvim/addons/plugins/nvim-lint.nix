{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      statix
    ];
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = [ "statix" ];
      };

    };
  };
}

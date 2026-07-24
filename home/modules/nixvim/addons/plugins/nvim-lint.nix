{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      markdownlint-cli2
      shellcheck
      statix
    ];
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = [ "statix" ];
        sh = [ "shellcheck" ];
        markdown = [ "markdownlint-cli2" ];
      };

    };
  };
}

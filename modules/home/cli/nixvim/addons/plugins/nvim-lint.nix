{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.home.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
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
          "markdown.mdx" = [ "markdownlint-cli2" ];
        };

      };
    };
  };
}
